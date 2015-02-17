# OutcomeResolver

The purpose of this gem is to provide an outcome handling API to clients of service objects than have more associated outcome states that success or failure A jobletter subscription service for example might have many outcomes depending on the user status, session and success or failure of the subscription.

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

One might use the outcome resolver API as follows:
  - instantiate a service object and have it perform all required actions
  - upon completion of those actions handle the respective outcomes by invoking the method `resolve_outcome` passing it a block
  - inside of this block handle each case by invoking the `when` method passing it the name of the outcome and the handling logic as a block


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
  .when :user_signed_in do |email_confirmed|
    if email_confirmed
      flash[:notice] = "Howdy, bitte bestaetige noch deine Email-Adresse."
    end
  end

end

```
Inside the service declare all expected outcomes via the `outcomes` class macro which expects one or more symbols. When the service actions are performed flags corresponding to the specified outcomes have to be set. This is done by simply passing a boolean value to a method of the same name as the outcome declared in the outcomes argument list. These methods can take an optional number of arguments that is passed to the block in the `when` clause.

```ruby

class JobletterSubscriptionService

  include OutcomeResolver

  outcomes :email_missing, :email_invalid

  def subscribe(email)
    unless current_user.signed_in?
      sign_in(current_user)
      user_signed_in true, current_user.email_confirmed?
    end

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
