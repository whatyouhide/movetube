class Hash
  # Select only `keys` keys from this hash.
  # @param [Hash] keys
  # @return [Hash]
  def only_keys(*keys)
    select { |key, value| keys.include?(key) }
  end
end
