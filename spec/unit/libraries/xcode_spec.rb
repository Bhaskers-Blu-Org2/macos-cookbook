require 'spec_helper'
include MacOS

describe MacOS::Xcode do
  context 'when initialized with beta and GM seeds available' do
    before do
      allow_any_instance_of(MacOS::Xcode).to receive(:authenticate_with_apple)
        .and_return(true)
      allow_any_instance_of(MacOS::Xcode).to receive(:find_apple_id)
        .and_return('apple_id': 'apple_id', 'password': 'password')
      allow_any_instance_of(MacOS::Xcode).to receive(:available_versions)
        .and_return(<<-XCVERSION_OUTPUT
                    8
                    8.1
                    8.2
                    8.2.1
                    8.3
                    8.3.1
                    8.3.2
                    8.3.3
                    9
                    9.0.1
                    9.1
                    9.2
                    9.3
                    9.4 beta
                    10 GM seed
                    XCVERSION_OUTPUT
                   )
    end
    it 'returns the name of Xcode 10 GM when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('10.0')
      expect(xcode.version).to eq '10 GM seed'
    end
    it 'returns the name of Xcode 9.4 beta when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.4')
      expect(xcode.version).to eq '9.4 beta'
    end
    it 'returns the name of Xcode 9.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.3')
      expect(xcode.version).to eq '9.3'
    end
    it 'returns the name of Xcode 9 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.0')
      expect(xcode.version).to eq '9'
    end
    it 'returns the name of Xcode 8.3.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('8.3.3')
      expect(xcode.version).to eq '8.3.3'
    end
  end
end

describe MacOS::Xcode::Simulator do
  context 'when provided an available list of simulators' do
    before do
      allow_any_instance_of(MacOS::Xcode::Simulator).to receive(:available_versions)
        .and_return(<<-XCVERSION_OUTPUT
                    Xcode 9.2 (/Applications/Xcode-9.2.app)
                    iOS 8.1 Simulator (not installed)
                    iOS 8.2 Simulator (not installed)
                    iOS 8.3 Simulator (not installed)
                    iOS 8.4 Simulator (not installed)
                    iOS 9.0 Simulator (not installed)
                    iOS 9.1 Simulator (not installed)
                    iOS 9.2 Simulator (not installed)
                    iOS 9.3 Simulator (not installed)
                    iOS 10.0 Simulator (not installed)
                    iOS 10.1 Simulator (not installed)
                    tvOS 9.0 Simulator (not installed)
                    tvOS 9.1 Simulator (not installed)
                    tvOS 9.2 Simulator (not installed)
                    tvOS 10.0 Simulator (not installed)
                    watchOS 2.0 Simulator (not installed)
                    watchOS 2.1 Simulator (not installed)
                    watchOS 2.2 Simulator (not installed)
                    tvOS 10.1 Simulator (not installed)
                    iOS 10.2 Simulator (not installed)
                    watchOS 3.1 Simulator (not installed)
                    iOS 10.3.1 Simulator (not installed)
                    watchOS 3.2 Simulator (not installed)
                    tvOS 10.2 Simulator (not installed)
                    iOS 11.0 Simulator (not installed)
                    watchOS 4.0 Simulator (not installed)
                    tvOS 11.0 Simulator (not installed)
                    tvOS 11.1 Simulator (not installed)
                    watchOS 4.1 Simulator (not installed)
                    iOS 11.1 Simulator (not installed)
                    XCVERSION_OUTPUT
                   )
    end
    it 'returns the latest semantic version of iOS 11' do
      s = MacOS::Xcode::Simulator.new('11')
      expect(s.version).to eq 'iOS 11.1'
    end
    it 'returns the latest semantic version of iOS 10' do
      s = MacOS::Xcode::Simulator.new('10')
      expect(s.version).to eq 'iOS 10.3.1'
    end
    it 'returns the latest semantic version of iOS 9' do
      s = MacOS::Xcode::Simulator.new('9')
      expect(s.version).to eq 'iOS 9.3'
    end
  end
end
