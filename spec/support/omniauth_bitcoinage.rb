module OmniAuthBitcoinage
  def mock_auth_hash_for(user)
    binding.pry
  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.
    OmniAuth.config.add_mock(user.provider.to_sym, {
      'provider' => user.provider,
      'uid' => user.uid,
      'info' => {
        'nickname' => user.username,
      }
    })
  end
end
