RSpec.describe Manufacturable::Builder do
  describe '.build' do
    subject(:build) { described_class.build(type, key, args) }

    let(:type) { 'type' }
    let(:key) { 'key' }
    let(:args) { 'args' }
    let(:klasses) { Set.new }

    before do
      allow(Manufacturable::Registrar).to receive(:get).and_return(klasses)
    end

    it 'gets the classes from the Registrar' do
      build

      expect(Manufacturable::Registrar).to have_received(:get).with(type, key)
    end

    context 'when the class set is empty' do
      let(:klasses) { Set.new }

      it { should be_nil }
    end

    context 'when the class set is NOT empty' do
      let(:klass) { class_double('Klass', new: klass_instance) }
      let(:klass_instance) { instance_double('Klass') }
      let(:klasses) { Set.new([klass]) }

      context 'and the set contains one class' do
        context 'and the params are NOT named' do
          it 'instantiates an object with the provided args' do
            build

            expect(klass).to have_received(:new).with(args)
          end

          it 'returns an instance of the class in the set' do
            expect(build).to eq(klass_instance)
          end
        end

        context 'and the params are named' do
          let(:klass) { Class.new { def initialize(param:); end } }

          around do |example|
            original_stderror = $stderr
            $stderr = StringIO.new
            example.run
            $stderr = original_stderror
          end

          it 'does not raise a warning' do
            described_class.build(type, key, param: 'param')

            expect($stderr.string).to be_empty
          end
        end
      end

      context 'and the set contains more than one class' do
        let(:klass1) { class_double('Klass1', new: klass1_instance) }
        let(:klass2) { class_double('Klass2', new: klass2_instance) }
        let(:klass1_instance) { instance_double('Klass1') }
        let(:klass2_instance) { instance_double('Klass2') }
        let(:klasses) { Set.new([klass1, klass2]) }

        it 'instantiates an object with the provided args' do
          build

          expect(klasses).to all(have_received(:new).with(args))
        end

        it 'returns an instance of every class in the set' do
          expect(build).to eq([klass1_instance, klass2_instance])
        end
      end
    end
  end

  describe '.build_one' do
    subject(:build_one) { described_class.build_one(type, key, args) }

    let(:type) { 'type' }
    let(:key) { 'key' }
    let(:args) { 'args' }
    let(:klasses) { Set.new }

    before do
      allow(Manufacturable::Registrar).to receive(:get).and_return(klasses)
    end

    it 'gets the classes from the Registrar' do
      build_one

      expect(Manufacturable::Registrar).to have_received(:get).with(type, key)
    end

    context 'when the class set is empty' do
      let(:klasses) { Set.new }

      it { should be_nil }
    end

    context 'when the class set is NOT empty' do
      let(:klass) { class_double('Klass', new: klass_instance) }
      let(:klass_instance) { instance_double('Klass') }
      let(:klasses) { Set.new([klass]) }

      context 'and the set contains one class' do
        context 'and the params are NOT named' do
          it 'instantiates an object with the provided args' do
            build_one

            expect(klass).to have_received(:new).with(args)
          end

          it 'returns an instance of the class in the set' do
            expect(build_one).to eq(klass_instance)
          end
        end

        context 'and the params are named' do
          let(:klass) { Class.new { def initialize(param:); end } }

          around do |example|
            original_stderror = $stderr
            $stderr = StringIO.new
            example.run
            $stderr = original_stderror
          end

          it 'does not raise a warning' do
            described_class.build_one(type, key, param: 'param')

            expect($stderr.string).to be_empty
          end
        end
      end

      context 'and the set contains more than one class' do
        let(:klass1) { class_double('Klass1', new: klass1_instance) }
        let(:klass2) { class_double('Klass2', new: klass2_instance) }
        let(:klass1_instance) { instance_double('Klass1') }
        let(:klass2_instance) { instance_double('Klass2') }
        let(:klasses) { Set.new([klass1, klass2]) }

        it 'instantiates the last class with the provided args' do
          build_one

          expect(klass1).not_to have_received(:new).with(args)
          expect(klass2).to have_received(:new).with(args)
        end

        it 'returns an instance of the last class in the set' do
          expect(build_one).to eq(klass2_instance)
        end
      end
    end
  end

  describe '.build_all' do
    subject(:build_all) { described_class.build_all(type, key, args) }

    let(:type) { 'type' }
    let(:key) { 'key' }
    let(:args) { 'args' }
    let(:klasses) { Set.new }

    before do
      allow(Manufacturable::Registrar).to receive(:get).and_return(klasses)
    end

    it 'gets the classes from the Registrar' do
      build_all

      expect(Manufacturable::Registrar).to have_received(:get).with(type, key)
    end

    context 'when the class set is empty' do
      let(:klasses) { Set.new }

      it { should be_empty }
    end

    context 'when the class set is NOT empty' do
      let(:klass) { class_double('Klass', new: klass_instance) }
      let(:klass_instance) { instance_double('Klass') }
      let(:klasses) { Set.new([klass]) }

      context 'and the set contains one class' do
        context 'and the params are NOT named' do
          it 'instantiates an object with the provided args' do
            build_all

            expect(klass).to have_received(:new).with(args)
          end

          it 'returns an array containing an instance of the class in the set' do
            expect(build_all).to eq([klass_instance])
          end
        end

        context 'and the params are named' do
          let(:klass) { Class.new { def initialize(param:); end } }

          around do |example|
            original_stderror = $stderr
            $stderr = StringIO.new
            example.run
            $stderr = original_stderror
          end

          it 'does not raise a warning' do
            described_class.build_all(type, key, param: 'param')

            expect($stderr.string).to be_empty
          end
        end
      end

      context 'and the set contains more than one class' do
        let(:klass1) { class_double('Klass1', new: klass1_instance) }
        let(:klass2) { class_double('Klass2', new: klass2_instance) }
        let(:klass1_instance) { instance_double('Klass1') }
        let(:klass2_instance) { instance_double('Klass2') }
        let(:klasses) { Set.new([klass1, klass2]) }

        it 'instantiates an object with the provided args' do
          build_all

          expect(klasses).to all(have_received(:new).with(args))
        end

        it 'returns an instance of every class in the set' do
          expect(build_all).to eq([klass1_instance, klass2_instance])
        end
      end
    end
  end
end
