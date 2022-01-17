# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GreenDay::AtcoderClient do
  describe 'new' do
    subject { described_class.new }

    context 'with .cookie-store' do
      before do
        File.write('.cookie-store', <<~SESSION)
          ---
          - !ruby/object:HTTP::Cookie
            name: REVEL_SESSION
            value: session_value
            domain: atcoder.jp
            for_domain: false
            path: "/"
            secure: false
            httponly: true
            expires:
            max_age: 15552000
            created_at: &1 2020-02-09 20:10:27.515657224 +09:00
            accessed_at: *1
        SESSION
      end

      after do
        File.delete('.cookie-store')
      end

      it 'initializes with cookie' do
        expect(subject.cookie_jar.store.instance_variable_get(:@jar)).not_to be_empty
      end

      context 'with cookie-store ## old file name' do
        before do
          File.rename('.cookie-store', 'cookie-store')
        end

        after do
          File.rename('cookie-store', '.cookie-store')
        end

        it 'warns file rename' do
          expect { subject }
            .to output("cookie-store needs rename .cookie-store\n").to_stderr
        end

        it 'initializes with cookie' do
          expect(subject.cookie_jar.store.instance_variable_get(:@jar)).not_to be_empty
        end
      end
    end

    context 'without cookie-store' do
      it 'initializes without cookie' do
        expect(subject.cookie_jar.store.instance_variable_get(:@jar)).to be_empty
      end
    end
  end
end
