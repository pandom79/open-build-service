class CheckUpgradeJob < ApplicationJob
  
  def perform
    affected_rows = 0 
    is_error = false
    
    logger.debug "Running check upgrade job ...."

    #Get OBS Instance Super User
    user = User.find_by(realname: 'OBS Instance Superuser', state: 'confirmed')
    if ! user.present?
      raise "OBS Instance Super User not found !"
    end

    #Retrieve the configuration parameters (limit and offset)
    limit, offset = get_conf_params
    #Count the records
    check_upgrades_count = PackageCheckUpgrade.order(:package_id).count
    if check_upgrades_count > 0
      #Retrieve all "check upgrade" by limit and offset ordered by package_id
      check_upgrades = PackageCheckUpgrade.order(:package_id).limit(limit).offset(offset)
      
      check_upgrades.each do |check_upgrade|
        affected_rows += 1

        logger.debug "Check upgrade for package id ="
        logger.debug check_upgrade.package_id

        #Execute check
        result = check_upgrade.run_checkupgrade(user.login)
        if ! result.present?
          logger.error "An error has occurred in run_checkupgrade(). Result is not defined!"
          return
        end
        #Set state and output
        check_upgrade.set_output_and_state_by_result(result)

        logger.debug "Check upgrade state = "
        logger.debug check_upgrade.state
        logger.debug "Check upgrade output = "
        logger.debug check_upgrade.output

        begin
          #Update the data
          ret = check_upgrade.update(output: check_upgrade.output, state: check_upgrade.state)

          logger.debug "ret di update"
          logger.debug ret.to_s

          logger.debug "Update execute successfully!"

          #FIXME Add the eventual sending of the email ....

        rescue => exception
          logger.error "Exception in check upgrade job!"
          exception.message
          exception.backtrace
          is_error = true
          break
        end

      end

      logger.debug "Offset before = "
      logger.debug offset
      logger.debug "Affected rows = "
      logger.debug affected_rows
      logger.debug "is_error = "
      logger.debug is_error.to_s

      if is_error
        #If an error has occurred, restart from this offset
        set_conf_params(offset)
      else
        if ! is_error and offset == check_upgrades_count
          #If nothing error has occurred and the offset is equal to the total number of records then
          #reset the offset to restart from 0
          set_conf_params(0)
        else
          #Process new offset and update it
          offset += affected_rows
          set_conf_params(offset)
        end
      end

      logger.debug "Offset after = "
      logger.debug offset

    end

    logger.debug "Check upgrade job finished!"

  end

  private

  def logger
    Rails.logger
  end

  def get_conf_params
    check_upgrade_param = YAML.load_file("#{Rails.root}/config/check_upgrade.yml")
    if ! check_upgrade_param.present?
      raise "Error in get_conf_params: check_upgrade.yml not found!"
    else
      limit = check_upgrade_param['checkupgrade']['limit']
      offset = check_upgrade_param['checkupgrade']['offset'] 
      if ! limit.present? or ! offset.present?
        raise "Error: limit and offset not correctly set in #{Rails.root}/config/check_upgrade.yml!"
      else
        return limit, offset
      end 
    end
  end

  def set_conf_params(offset)
    check_upgrade_param = YAML.load_file("#{Rails.root}/config/check_upgrade.yml")
    if ! check_upgrade_param.present?
      raise "Error in set_conf_params: check_upgrade.yml not found!"
    else
      check_upgrade_param['checkupgrade']['offset'] = offset
      #Store
      File.open("#{Rails.root}/config/check_upgrade.yml", "w") { |file| file.write check_upgrade_param.to_yaml } 
    end
  end

end