class WizardStepsPresenter < BasePresenter
  @@wizard_step = 1
  @@activated = @@skip_active = false
  def initialize(step, name, link, done)
    @step = step
    @name = name
    @link = link
    @done = done
  end

  def self.steps(steps_limit, organizer)
    @@wizard_step = 0
    completely_verified = organizer.verified? && personal_account_verified(organizer) &&
      organizer.marketplace.try(:registered_bank_account) && organizer.tours.any?
    completely_verified ? '' : yield(self)
  end

  def self.render(step_name, step_link, done = false)
    @@skip_active = @@activated
    @@activated = true if !done && !@@skip_active
    new(@@wizard_step+=1, step_name, step_link, done).render_step
  end

  def render_step
    h.link_to @link, class: "step #{active_css} #{done_css}", data: { desc: @name } do
      h.concat(!@@activated ? h.content_tag(:i, '', class: 'fa fa-check') : @step)
    end
  end

  private

  def self.personal_account_verified(organizer)
    organizer.try(:marketplace) && organizer.marketplace.is_active? &&
      organizer.marketplace.account_user_data_verified
  end

  def active_css
    return @@activated && !@@skip_active ? 'active' : ''
  end

  def done_css
    @done ? 'done' : ''
  end
end
