# OutcomeResolver

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'outcome_resolver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install outcome_resolver

## Usage

The purpose of this gem is to provide an outcome handling API to clients of service objects than have more associated outcome states that success or failure A jobletter subscription service for example might have many outcomes depending on the user status, session and success or failure of the subscription. In this case on might use the outcome resolver API as follows:

```ruby

service = JobletterSubscriptionService.new(session)
service.subscribe(params[:email])

service.resolve_outcome do |outcome|
  outcome
  .when :email_missing do
    flash[:alert] = "Bitte gib deine Email-Adresse an."
  end
  .when :email_invalid do
    flash[:alert] = "Diese Email-Adresse ist nicht gültig."
  end


end

```
Inside the service declare all expected outcomes via the `outcomes` class macro which expects one or more symbols. When the service actions are performed flags corresponding to the specified outcomes have to be set. This is done by simply passing a boolean value to a method of the same name as the outcome declared in the outcomes argument list.

```ruby

class JobletterSubscriptionService

  include OutcomeResolver

  outcomes :email_missing, :email_invalid

  def subscribe(email)
    email_missing false
    validate_email(email)
    #perform rest of subscription logic
  end

  def validate_email(email)
    if EmailValidationService.valid?(email)
      email_invalid false
    else
      email_invalid true
    end
  end

end

```
TODO
 - `when` blocks need to be able to pass payload
 - define methods in clean room to avoid clashes in same namespace
## Contributing

1. Fork it ( https://github.com/[my-github-username]/outcome_resolver/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
