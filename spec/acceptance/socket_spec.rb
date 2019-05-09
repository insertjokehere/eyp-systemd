require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'systemd class' do
  context 'socket' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'systemd': }

      systemd::socket { 'vago':
        description   => 'vago Server Activation Socket',
        listen_stream => [ '6565' ],
        wantedby      => [ 'sockets.target' ],
      }


      systemd::service { 'vago':
        description    => 'vago server',
        requires       => [ 'vago.socket' ],
        documentation  => 'man:in.tftpd',
        execstart      => [ "/bin/sleep 30" ],
        standard_input => 'socket',
        also           => [ 'vago.socket' ],
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/etc/systemd/system/vago.socket") do
      it { should be_file }
      its(:content) { should match 'ListenStream=6565' }
    end

    it "systemctl status" do
      expect(shell("systemctl status vago.socket").exit_code).to be_zero
    end

  end
end