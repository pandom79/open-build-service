module Person
  class NotificationsController < ApplicationController
<<<<<<< HEAD
    include Person::Errors

    MAX_PER_PAGE = 300
    ALLOWED_FILTERS = ['requests', 'incoming_requests', 'outgoing_requests'].freeze

    before_action :check_feature_and_beta_toggles
    before_action :check_filter_type
=======
    MAX_PER_PAGE = 300
>>>>>>> bdb45c668c (Create a read-only api for notifications)

    # GET /my/notifications
    def index
      @notifications = paginated_notifications
      @notifications_total = @notifications.count
    end

<<<<<<< HEAD
    private

=======
>>>>>>> bdb45c668c (Create a read-only api for notifications)
    def show_all(notifications)
      total = notifications.size
      notifications.page(params[:page]).per([total, MAX_PER_PAGE].min)
    end

    def fetch_notifications
      notifications_for_subscribed_user = NotificationsFinder.new(policy_scope(Notification))

      filtered_notifications = if params[:project]
                                 notifications_for_subscribed_user.for_project_name(params[:project])
                               else
                                 notifications_for_subscribed_user.for_subscribed_user
                               end
      # We are limiting it just for BsRequests
<<<<<<< HEAD
      NotificationsFinder.new(filtered_notifications).for_notifiable_type(@filter_type)
=======
      NotificationsFinder.new(filtered_notifications).for_notifiable_type('requests')
>>>>>>> bdb45c668c (Create a read-only api for notifications)
    end

    def paginated_notifications
      notifications = fetch_notifications
      params[:page] = notifications.page(params[:page]).total_pages if notifications.page(params[:page]).out_of_range?
      params[:show_all] ? show_all(notifications) : notifications.page(params[:page])
    end
<<<<<<< HEAD

    def check_filter_type
      @filter_type = params.fetch(:notifications_type, 'requests')
      raise FilterNotSupportedError unless ALLOWED_FILTERS.include?(@filter_type)
    end

    def check_feature_and_beta_toggles
      raise NotFoundError unless Flipper.enabled?(:notifications_redesign, User.session) && User.session.in_beta?
    end
=======
>>>>>>> bdb45c668c (Create a read-only api for notifications)
  end
end
