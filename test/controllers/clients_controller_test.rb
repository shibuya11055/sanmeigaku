require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    assert_routing({ method: 'get', path: '/clients' }, { controller: 'clients', action: 'index' })
  end

  test 'should get show' do
    assert_routing({ method: 'get', path: '/clients/1' }, { controller: 'clients', action: 'show', id: '1' })
  end

  test 'should get new' do
    assert_routing({ method: 'get', path: '/clients/new' }, { controller: 'clients', action: 'new' })
  end

  test 'should get edit' do
    assert_routing({ method: 'get', path: '/clients/1/edit' }, { controller: 'clients', action: 'edit', id: '1' })
  end
end
