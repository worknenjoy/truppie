require 'test_helper'

class WizardStepsPresenterTest < ActiveSupport::TestCase
  setup do
    @organizer = organizers(:guide_mkt_validated)
    @described_class = WizardStepsPresenter
  end

  test "should yield the presenter class itself" do
    @described_class.steps(4, @organizer){ |step| assert_equal @described_class, step }
  end

  test "should result formatted 'step' elements with 'Perfil' step name" do
    result = @described_class.render('Perfil', 'www.google.com')

    assert result.include?('Perfil')
  end

  test "should result formatted 'step' elements with 'done' class" do
    result = @described_class.render('Perfil', 'www.google.com', true)

    assert result.include?('done')
  end
end
