require "test_helper"

class LicitacoesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get licitacoes_index_url
    assert_response :success
  end

  test "should get new" do
    get licitacoes_new_url
    assert_response :success
  end

  test "should get create" do
    get licitacoes_create_url
    assert_response :success
  end
end
