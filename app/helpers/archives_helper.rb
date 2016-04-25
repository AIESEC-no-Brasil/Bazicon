module ArchivesHelper

  def download(path)
    $client.shares(path)
    #shareble_link = $client.shares(path)
    res = Net::HTTP.get_response(URI("#{$client.shares(path)['url']}"))
    a = "#{res['location'].to_s[0...-1]}1"
  end

end