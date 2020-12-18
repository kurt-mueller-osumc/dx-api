RSpec.describe DX::Api::ErrorHandler do
  describe '#error' do
    context 'when type is \'InvalidAuthentication\'' do
      let(:response) { error_response(type: 'InvalidAuthentication', message: 'Invalid Authentication') }

      subject(:error) { described_class.from_response(response).error }

      it { is_expected.to be(DX::Api::InvalidAuthenticationError) }
    end
  end

  def error_response(type:, message:)
    instance_double(DX::Api::Response,
      body: {
        'error' => {
          'type' => type,
          'message' => message
        }
      },
      code: 400
    )
  end
end
