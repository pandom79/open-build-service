require 'rails_helper'

RSpec.describe Person::NotificationsController do
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> dd863c268e193e2460851b3ae507e0a2b9772d1c
  let(:user) { create(:confirmed_user, :with_home, :in_beta) }

  render_views

  describe 'Check if user is in beta or feature flag is enabled' do
    let(:user) { create(:confirmed_user, :with_home) }

    before do
      toggle_notifications_redesign
      login user
      get :index, format: :xml
    end

    context 'user not in beta' do
      let(:toggle_notifications_redesign) { Flipper[:notifications_redesign].enable }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'Feature :notifications_redesign is disabled' do
      let(:toggle_notifications_redesign) { Flipper[:notifications_redesign].disable }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'filter check' do
    before do
      Flipper[:notifications_redesign].enable
      login user
      get :index, params: params
    end

    context 'default filter' do
      let(:params) { { format: :xml } }

      it { expect(response).to have_http_status(:success) }
    end

    context 'bad filter' do
      let(:params) { { format: :xml, notifications_type: 'foobar' } }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end

  describe 'index' do
    context 'called by authorized user' do
      let!(:notifications) { create_list(:web_notification, 2, :request_state_change, subscriber: user) }

      before do
        Flipper[:notifications_redesign].enable
<<<<<<< HEAD
=======
=======
  let(:user) { create(:confirmed_user, :with_home, :in_beta) }

>>>>>>> 49b77d92ef (Add filter options to the Notifications API endpoint)
  render_views

  describe 'Check if user is in beta or feature flag is enabled' do
    let(:user) { create(:confirmed_user, :with_home) }

    before do
      toggle_notifications_redesign
      login user
      get :index, format: :xml
    end

    context 'user not in beta' do
      let(:toggle_notifications_redesign) { Flipper[:notifications_redesign].enable }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'Feature :notifications_redesign is disabled' do
      let(:toggle_notifications_redesign) { Flipper[:notifications_redesign].disable }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'filter check' do
    before do
      Flipper[:notifications_redesign].enable
      login user
      get :index, params: params
    end

    context 'default filter' do
      let(:params) { { format: :xml } }

      it { expect(response).to have_http_status(:success) }
    end

    context 'bad filter' do
      let(:params) { { format: :xml, notifications_type: 'foobar' } }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end

  describe 'index' do
    context 'called by authorized user' do
      let!(:notifications) { create_list(:web_notification, 2, :request_state_change, subscriber: user) }

      before do
<<<<<<< HEAD
>>>>>>> bdb45c668c (Create a read-only api for notifications)
=======
        Flipper[:notifications_redesign].enable
>>>>>>> d9f2a53e17 (Add check for feature flag and beta to the notifications API endpoint)
=======
>>>>>>> dd863c268e193e2460851b3ae507e0a2b9772d1c
        login user
        get :index, format: :xml

        notifications.each do |notification|
          notification.projects << user.home_project
          notification.save
        end
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(response.body).to include('<notifications count="2">') }

      context 'filter by project finds results' do
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        before do
          login user
          get :index, params: { format: :xml, project: user.home_project_name }
=======
        let(:project) { notifications.first.projects.first }

        before do
          login user
          get :index, params: { format: :xml, project: project }
>>>>>>> bdb45c668c (Create a read-only api for notifications)
=======
        before do
          login user
          get :index, params: { format: :xml, project: user.home_project_name }
>>>>>>> 49b77d92ef (Add filter options to the Notifications API endpoint)
=======
        before do
          login user
          get :index, params: { format: :xml, project: user.home_project_name }
>>>>>>> dd863c268e193e2460851b3ae507e0a2b9772d1c
        end

        it { expect(response).to have_http_status(:success) }
        it { expect(response.body).to include('<notifications count="2">') }
      end

      context 'filter by project doe not find results' do
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
        let(:project) { notifications.first.projects.first }

>>>>>>> bdb45c668c (Create a read-only api for notifications)
=======
>>>>>>> 49b77d92ef (Add filter options to the Notifications API endpoint)
=======
>>>>>>> dd863c268e193e2460851b3ae507e0a2b9772d1c
        before do
          login user
          get :index, params: { format: :xml, project: 'home:hans' }
        end

        it { expect(response).to have_http_status(:success) }
        it { expect(response.body).to include('<notifications count="0"/>') }
      end
    end

    context 'called by unauthorized user' do
      before do
        get :index, format: :xml
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
