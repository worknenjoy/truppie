class WizardStepsPresenter < BasePresenter
  def initialize(profile_verified, account_verified, bank_account_verified, any_tour_created_verified)
    @next_step = 1
    @verified_steps = {
      1 => !!profile_verified,
      2 => !!account_verified,
      3 => !!bank_account_verified,
      4 => !!any_tour_created_verified
    }
  end

  def render(current_step, step_name, step_link)
    h.link_to step_link, class: "step #{active_css(current_step)} #{done_css(current_step)}", data: { desc: step_name } do
      h.concat(done?(current_step)? h.content_tag(:i, '', class: 'fa fa-check') : current_step)
    end
  end

  def completely_verified?
    @verified_steps.all?{|step, verified| verified }
  end

  # Wizard instance generator
  def self.steps(organizer)
    wizard_instance = new(organizer.verified?, personal_account_verified(organizer),
      organizer.marketplace.try(:bank_account_verified), organizer.tours.any? || organizer.guidebooks.any?)
    wizard_instance.completely_verified?? '' : yield(wizard_instance)
  end

  private

  def self.personal_account_verified(organizer)
    organizer.try(:marketplace) && organizer.marketplace.is_active? &&
      organizer.marketplace.account_user_data_verified
  end

  def active_css(current_step)
    @verified_steps[current_step-1] && !@verified_steps[current_step] ? 'active' : ''
  end

  def done_css(current_step)
    if done?(current_step)
      @next_step = current_step + 1
      return 'done'
    else
      ''
    end
  end

  def done?(current_step)
    @verified_steps.select{|step, verified| step <= current_step }.all?{|step, verified| verified }
  end
end
