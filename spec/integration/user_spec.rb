require 'spec_helper'

describe "AppNexus User" do
  before(:all) do
    @connection = connection
    @user_service = AppnexusApi::UserService.new(@connection)
  end

  def current_user
    @current_user ||= @user_service.get(current:1).first
  end

  let(:new_user_hash) do
    {
       username: 'rspec_user',
       password: 'rspec_user',
       user_type: 'member',
       entity_id: current_user.entity_id,
       first_name: "rspec",
       last_name: "test",
       email: "rspec@api.appnexus.com",
       state: "inactive",
       api_login: true, #this can only be set by Appnexus
     }
  end

  it 'returns the current user' do
    expect(current_user.api_login).to be true
  end

  #users aren't delete-able
  #it 'create' do
  #  @new_user = @user_service.create({}, new_user_hash)
  #  expect(@user_service.get(id: @new_user.id).last_name).to eq "test"
  #end

  it 'update' do
    last_name ||= current_user.last_name
    current_user.update({}, { last_name: "test" })
    updated_user = @user_service.get(id: current_user.id).first
    #restore the last_name before expecting
    current_user.update({}, { last_name: last_name })
    expect(updated_user.last_name).to eq "test"
  end

end
