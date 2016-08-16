# Sets up basic actions for all controllers
#
# This module once included in any controller adds the basic
# CRUD actions to create a JSON API to communicate with the
# front end. It also sets up the basic filters to get the
# collection of objects, individual objects and controls the
# params.
module BaseController
  extend ActiveSupport::Concern
  included do
    after_action :verify_policy_scoped, only: :index
    before_action :authenticate_user!, except: :external
  end

  # Define the class methods
  #
  # This does not define actions
  module ClassMethods
    # Includes the actions to the controller
    #
    #
    def add_basic_actions(options = {})
      options[:only] ||= []
      before_action :set_object, only: [:show, :update, :destroy] + options[:only]

      class_eval <<-RUBY

        private

        def collection
          #{options[:collection]}
        end

        def set_object
          @object = collection.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def safe_params
          params
            .require( #{options[:require]} )
            .permit( #{options[:params]} )
        end
      RUBY

      include BaseController::Actions
    end
  end

  module Actions
    def index
       @collection = collection
    end

    def show
    end

    def create
      Rails.logger.debug safe_params
      Rails.logger.debug params
      @object = collection.new(safe_params)
      if @object.save!
        render :show, status: :created
      else
        render json: @object.errors, status: :unprocessable_entity
      end
    end

    def update
      if @object.update(safe_params)
        render :show, status: :ok
      else
        render json: @object.errors, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        @object.destroy
        head :ok
      rescue => e
        render json: {message: e}, status: :bad_request
      end
    end
  end
end
