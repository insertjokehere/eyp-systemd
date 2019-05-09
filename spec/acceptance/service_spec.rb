require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'systemd class' do
  context 'service' do
    it "cleanup" do
      expect(shell("pkill sleep; echo").exit_code).to be_zero
    end

    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'systemd': }

      class { 'systemd::logind': }

      systemd::service { 'test':
        execstart => '/bin/sleep 60',
        before    => Service['test'],
      }

      service { 'test':
        ensure  => 'running',
        require => Class['::systemd'],
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/etc/systemd/system/test.service") do
      it { should be_file }
      its(:content) { should match 'ExecStart=/bin/sleep 60' }
    end

    describe file("/etc/systemd/logind.conf") do
      it { should be_file }
      its(:content) { should match 'RemoveIPC=no' }
    end

    it "systemctl status" do
      expect(shell("systemctl status test").exit_code).to be_zero
    end

    it "check sleep" do
      expect(shell("ps -fea | grep [s]leep").exit_code).to be_zero
    end
  end
end
