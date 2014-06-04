require 'spec_helper'

describe 'backups', :type => :class do
  let(:facts) { { :hostname => 'test.mydomain.com' } }
  let(:params) { { :aws_access_key => 'asdfjkl', :aws_secret_key => 'asdf1234jkl5678', :bucket => 'mybucket' } }

  describe "class with default parameters" do

    it { should create_class('backups') }
    it { should contain_package('rubygem-backup').with_ensure('latest') }

    [ '/etc/backup', '/etc/backup/models', '/var/log/backup' ].each do |directory|
      it { should contain_file(directory).with(
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root'
      ) }
    end

    it { should create_file('/etc/backup/config.rb').with(
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0440'
    ) }

    it { should_not contain_beaver__stanza('/var/log/backup/backup.log') }

  end

  context 'with logging' do
    let(:params) { { :logstash => true } }

    it { should contain_beaver__stanza('/var/log/backup/backup.log') }
  end

end
