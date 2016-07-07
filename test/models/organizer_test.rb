require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
   test "one Organizer" do
     assert_equal 3, Organizer.count
   end
   
   test "organizer has two members" do
     assert_equal 2, Organizer.last.members.size
     assert_equal 'laurinha.sette@gmail.com', Organizer.last.members.first.user.email
     assert_equal 'alexanmtz@gmail.com', Organizer.last.members.last.user.email
   end
   
   test "adding bank info" do
     @organizer = organizers(:utopicos)
     
     @organizer.update_attributes(:active => true)
     
     @organizer.save()
     
     assert_equal @organizer.active, true
   end
   
   test "adding new complete account" do
     @organizer = organizers(:utopicos)
     
     @organizer.update_attributes(
        :active => true,
        :person_name => "Joao Cabral",
        :person_lastname => "Amado Pedro",
        :document_type => "CPF",
        :document_number => "887.215.373-56",
        :id_type => "RG",
        :id_number => "204256333",
        :id_issuer => "ssp",
        :id_issuerdate => "1990-01-01",
        :birthDate => "1990-01-01",
        :street => "Av. Brigadeiro Faria Lima",
        :street_number => "2927",
        :complement => "8 andar",
        :district => "Itaim",
        :zipcode => "01234-000",
        :city => "São Paulo",
        :state => "SP",
        :country => "BRA",
        :token => "blablbalbalba",
        :account_id => "MG-349232",
        :phone => "+55 (11) 965213244"
     )
     
     @organizer.save()
     
     assert_equal @organizer.bank_data.sort, {
          "email" => {
              "address" => "organizer@mail.com"
          },
          "person" => {
              "name" => "Joao Cabral",
              "lastName" => "Amado Pedro",
              "taxDocument" => {
                  "type" => "CPF",
                  "number"=> "887.215.373-56"
              },
              "identityDocument"=> {
                  "type"=> "RG",
                  "number"=> "204256333",
                  "issuer"=> "ssp",
                  "issueDate"=> "1990-01-01"
              },
              "birthDate" => "1990-01-01",
              "phone" => {
                  "countryCode" => "55",
                  "areaCode"=> "11",
                  "number" => "965213244"
              },
              "address" => {
                  "street" => "Av. Brigadeiro Faria Lima",
                  "streetNumber" => "2927",
                  "complement"=> "8 andar",
                  "district" => "Itaim",
                  "zipcode" => "01234-000",
                  "city" => "São Paulo",
                  "state" => "SP",
                  "country" => "BRA"
              }
          },
          "businessSegment" => {
              "id" => "37"
          },
          "site" => "http://www.truppie.com",
          "type" => "MERCHANT",
          "transparentAccount" => "true"
      }.sort
      
      assert_equal @organizer.bank_info, {
        "id" => "MG-349232",
        "token" => "blablbalbalba"
      }
      
   end
   
   test "validating a activation with a nonvalid entry" do
     @organizer = organizers(:utopicos)
     
     organizer_nonvalid = @organizer.valid_account
     
     #puts organizer_nonvalid.inspect
     
     assert_equal organizer_nonvalid, false
   end
   
   test "validating a activation with a valid entry" do
     @organizer = organizers(:utopicos_marketplace)
     
     organizer_valid = @organizer.valid_account
     
     #puts organizer_valid.inspect
     
     assert_equal organizer_valid, true
   end
   
   
   
end
