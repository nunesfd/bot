defmodule DevtipsBot.App.Cache do

  @key_name :app_cache

  def get(key) do
    Cachex.get(@key_name, key)
  end

  def put(key, data) do
    Cachex.put(@key_name, key, data)
  end

  def del(key) do
    Cachex.del(@key_name, key)
  end

end
