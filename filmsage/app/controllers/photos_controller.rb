class PhotosController < ApplicationController
  # skip_before_action :verify_authenticity_token
    def create
        render json: Photo.create(params["photo"])
    end
    def index
        render json: Photo.all
    end
    def update
        render json: Photo.update(params["photo"], params["id"])
    end
    def delete
        render json: Photo.delete(params["id"])
    end
end
