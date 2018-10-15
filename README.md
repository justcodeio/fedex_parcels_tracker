# FedexParcelsTracker


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fedex_parcels_tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fedex_parcels_tracker

When bundled, set up a initializer to provide CLIENT CREDENTIALS

Simply create a fedex_tracker.rb file in the initializers directory, and set it up like this:

```ruby
Fedex::Parcel.configure do |c|
  c.wsdl = 'the WSDL url for Your country'
  c.access_key = 'Your access key'
  c.method = 'the SOAP method to access data You need (as symbol)'
  c.tracking_in_data = 'the hash key value for data objects keys to correspond with the tracking_code placement (as symbol)'
  c.ssl_version = 'the version of TLS used by server You are connecting to'
  c.data = 'a hash to pass to Savon when calling the client'
end

'Example for FEDEX POLAND'

Fedex::Parcel.configure do |c|
  c.wsdl = 'https://poland.fedex.com/xxxxxxxxxxxxxxxxxxxxxx'
  c.access_key = 'Your access key'
  c.method = :pobierz_statusy_przesylki
  c.tracking_in_data = :numerPrzesylki
  c.ssl_version = :TLSv1_2
  c.data = {
    kodDostepu: c.access_key,
    numerPrzesylki: nil,
    czyOstatni: 0
  }
end
```
If no initializer is provided exception will be raised.

## Usage
Set of examples for FEDEX POLAND ":pobierz_statusy_przesylki" method responses

```ruby
Fedex::Parcel.track('1111111111111')
```
example success response :
```ruby
=>
{:statusy_przesylki=>
  [
    {:nr_p=>"1111111111111", :data_s=>"datetime", :skrot=>"XX", :opis=>"Kurier doręczył przesyłkę do odbiorcy.",
       :odd_symbol=>"XXX", :podpis_odbiorcy=>"XXXXXXX"},
    {:nr_p=>"1111111111111", :data_s=>"datetime", :skrot=>"XX", :opis=>"Przesyłka wydana do doręczenia kurierowi FedEx.", :odd_symbol=>"XXX"},
    {:nr_p=>"1111111111111", :data_s=>"datetime", :skrot=>"XX", :opis=>"Przesyłka w oddziale FedEx.", :odd_symbol=>"XXX"},
    {:nr_p=>"1111111111111", :data_s=>"datetime", :skrot=>"XXX", :opis=>"Przesyłka w oddziale FedEx.", :odd_symbol=>"XXX"},
    {:nr_p=>"1111111111111", :data_s=>"datetime", :skrot=>"XXX", :opis=>"Przesyłka w oddziale FedEx.", :odd_symbol=>"XXX"}
  ],
   :"@xmlns:ns2"=>"http://xxxxxxxxxxx.com/"}
```
example fail responses :

too short tracking_code provided  
```ruby
Fedex::Parcel.track('1111111')

RuntimeError: Invalid tracking code provided
```

```ruby
Fedex::Parcel.track(nil)

RuntimeError: Tracking code cannot be nil
```

Older parcels tracking information gets eventually deleted from FEDEX.
This is what eventually will be returned:

```ruby
Fedex::Parcel.track('22222222222222')
```
```ruby
=> {:error=>'Tracking code provided no longer found'}
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/justcodeio/fedex_parcels_tracker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
