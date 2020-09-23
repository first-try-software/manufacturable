RSpec.describe Manufacturable::Railtie do
  let!(:rails_railtie) do
    module Rails
      class Railtie
        def self.initializer(param, &block)
        end
      end
    end
  end

  describe '.load' do
    subject(:load) { described_class.load }

    before do
      allow(described_class).to receive(:rails_defined?).and_return(rails_defined?)
    end

    context 'when Rails is NOT defined' do
      let(:rails_defined?) { false }

      before { load }

      it 'does not define a railtie' do
        expect(
          ObjectSpace.each_object(Class).select { |klass| klass < Rails::Railtie }
        ).to be_empty
      end
    end

    context 'when Rails is defined' do
      let(:rails_defined?) { true }

      let(:app) { instance_double('app', config: config) }
      let(:config) { instance_double('config', eager_load: eager_load?) }

      before do
        allow(Rails::Railtie).to receive(:initializer).and_yield(app)
        allow(Manufacturable::Config).to receive(:require_method=)

        load
      end

      context 'when the rails app does NOT use eager loading' do
        let(:eager_load?) { false }

        it 'sets require method to require' do
          expect(Manufacturable::Config).to have_received(:require_method=).with(:require_dependency)
        end
      end

      context 'when the rails app uses eager loading' do
        let(:eager_load?) { true }

        it 'sets require method to require' do
          expect(Manufacturable::Config).to have_received(:require_method=).with(:require)
        end
      end
    end
  end
end