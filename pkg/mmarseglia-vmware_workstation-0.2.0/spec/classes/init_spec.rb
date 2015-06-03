require 'spec_helper'
describe 'vmware_workstation' do

    context 'default parameters' do
    let(:facts) { {:architecture => 'x86_64', :kernel => 'Linux', :memorysize_mb => '2000.00'} }

    it { should contain_class('vmware_workstation') }
    it { should compile }
    it { should contain_wget__fetch('vmware_workstation')}
    it { should contain_exec('install_workstation') }
  end

    context 'less than required memory' do
      let(:facts) { {:architecture => 'x86_64', :kernel => 'Linux', :memorysize_mb => '1999.00'} }
      it do
         expect {
           should compile
         }.to raise_error(/VMware Workstation requires at least 2GB of memory./)
       end
     end

     context 'architecture not 64bit' do
       let(:facts) { {:architecture => 'i386', :kernel => 'Linux', :memorysize_mb => '2000.00'} }
       it do
          expect {
            should compile
          }.to raise_error(/VMware Workstation requires a 64-bit operating system./)
        end
      end

      context 'parameter ensure absent' do
        let(:facts) { {:architecture => 'x86_64', :kernel => 'Linux', :memorysize_mb => '2000.00'} }
        let(:params) { {:ensure => 'absent'} }

        it { should contain_class('vmware_workstation') }
        it { should compile }
        it { should contain_exec('uninstall_workstation')}
        end

      context 'parameter neither installed nor absent' do
        let(:facts) { {:architecture => 'x86_64', :kernel => 'Linux', :memorysize_mb => '2000.00'} }
        let(:params) { {:ensure => 'ipsum'} }

        it do
           expect {
             should compile
           }.to raise_error(/Action unknown. VMware Workstation can be installed or absent/)
         end
      end

end
