# frozen_string_literal: true

# This table is used by the native Primero authentication to store the jti claims
# of JWTs that are currently valid.
class AllowlistedJwt < ApplicationRecord
  self.table_name = 'whitelisted_jwts'
end
