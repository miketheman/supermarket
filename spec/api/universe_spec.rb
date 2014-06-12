require 'spec_helper'

describe 'GET /universe' do
  let(:redis) { create(:cookbook, name: 'redis') }
  let(:apt) { create(:cookbook, name: 'apt') }
  let(:tarball) do
    File.open('spec/support/cookbook_fixtures/redis-test-v1.tgz')
  end

  before do
    redis_version = create(
      :cookbook_version,
      cookbook: redis,
      license: 'MIT',
      version: '1.2.0',
      tarball: tarball
    )
    apt_version = create(
      :cookbook_version,
      cookbook: apt,
      license: 'BSD',
      version: '1.1.0',
      tarball: tarball
    )
    create(:cookbook_dependency, cookbook_version: redis_version, cookbook: apt, name: 'apt', version_constraint: '>= 1.0.0')
    platform = create(:supported_platform, name: 'ubuntu', version_constraint: '= 12.04')
    create(:cookbook_version_platform, cookbook_version: redis_version, supported_platform: platform)
    create(:cookbook_version_platform, cookbook_version: apt_version, supported_platform: platform)

    get '/universe', format: :json
  end

  it 'returns a 200' do
    expect(response).to be_success
  end

  it 'should assign @cookbooks' do
    expect(assigns(:cookbooks)).to_not be_nil
  end

  it 'lists out cookbooks, their versions, dependencies and platforms' do
    body = json_body
    expect(body.keys).to eql(%w(redis apt))
    expect(body['redis'].keys).to include('1.2.0')
    expect(body['redis']['1.2.0'].keys.sort).to eql(%w(dependencies platforms ))
    expect(body['redis']['1.2.0']['platforms']).to eql('ubuntu' => '= 12.04')
    expect(body['redis']['1.2.0']['dependencies']).to eql('apt' => '>= 1.0.0')
  end
end
