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
            max_age: #{max_age}
            created_at: &1 2020-02-09 20:10:27.515657224 +09:00
            accessed_at: *1
        SESSION
      end

      after do
        File.delete('.cookie-store')
      end

      context 'with expired cookie' do
        let(:max_age) { 15_552_000 }

        it 'does not initialize with cookie' do
          expect(subject.cookie_jar.cookies).to be_empty
        end
      end

      context 'with no expired cookie' do
        let(:max_age) { 99_999_999 }

        it 'initializes with cookie' do
          expect(subject.cookie_jar.cookies).not_to be_empty
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
            expect(subject.cookie_jar.cookies).not_to be_empty
          end
        end
      end
    end

    context 'without cookie-store' do
      it 'initializes without cookie' do
        expect(subject.cookie_jar.cookies).to be_empty
      end
    end
  end
end
