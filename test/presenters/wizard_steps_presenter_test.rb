require 'test_helper'

class WizardStepsPresenterTest < ActiveSupport::TestCase
  setup do
    @organizer = organizers(:guide_mkt_validated)
    @described_class = WizardStepsPresenter
  end

  test "should yield the presenter class itself" do
    @described_class.steps(@organizer){ |step| assert_instance_of @described_class, step }
  end

  test "should result formatted 'step' elements with 'Perfil' step name" do
    @described_class.steps(@organizer){ |step_instance|
      result = step_instance.render(1, 'Perfil', 'www.google.com')

      assert result.include?('Perfil')
    }
  end
end
