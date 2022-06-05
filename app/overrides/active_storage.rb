# frozen_string_literal: true

# This is a civilized monkey patch to force user and record level authorization
# for the out-of-the-box Rails Active Storage controllers.
# We are not interested in re-writing active storage controllers: just locking them down
ActiveStorage::Blobs::RedirectController.class_eval do
  include ActiveStorageAuth
  before_action :authenticate_access!
  before_action :authorize_blob!
end

ActiveStorage::Representations::RedirectController.class_eval do
  include ActiveStorageAuth
  before_action :authenticate_access!
  before_action :authorize_blob!
end

ActiveStorage::DiskController.class_eval do
  include ActiveStorageAuth
  before_action :forbid!, only: %i[update create destroy]
end

ActiveStorage::DirectUploadsController.class_eval do
  include ActiveStorageAuth
  before_action :forbid!
end
