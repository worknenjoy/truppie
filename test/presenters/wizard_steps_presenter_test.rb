require 'test_helper'

class WizardStepsPresenterTest < ActiveSupport::TestCase
  setup do
    @described_class = WizardStepsPresenter
  end

  test "should yield the presenter class itself" do
    @described_class.steps(4){ |step| assert_equal @described_class, step }
  end

  test "should result formatted 'step' elements with 'active' class" do
    result = @described_class.render('Perfil', 'www.google.com')

    assert result.include?('active')
  end

  test "should result formatted 'step' elements with 'done' class" do
    result = @described_class.render('Perfil', 'www.google.com', true)

    assert result.include?('done')
  end
end
