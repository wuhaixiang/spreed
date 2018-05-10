Feature: participant

  Scenario: add participant to a group conversation
    Given I am logged in
    And I have opened the Talk app
    And I create a group conversation
    And I see that the sidebar is open
    And I see that the number of participants shown in the list is "1"
    And I see that "user0" is shown in the list of participants as a moderator
    When I add "admin" to the participants
    Then I see that the number of participants shown in the list is "2"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "admin" is shown in the list of participants as a normal participant

  Scenario: add participant to a group conversation when the participant is already logged in
    Given I act as John
    And I am logged in
    And I have opened the Talk app
    And I act as Jane
    And I am logged in as the admin
    And I have opened the Talk app
    And I act as John
    And I create a group conversation
    And I see that the sidebar is open
    When I add "admin" to the participants
    Then I act as Jane
    And I see that the "user0" conversation is shown in the list

  Scenario: add participant to a one-to-one conversation
    Given I am logged in
    And I have opened the Talk app
    And I create a one-to-one conversation with "talk-user0"
    And I see that the sidebar is open
    And I see that the number of participants shown in the list is "2"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "talk-user0" is shown in the list of participants as a moderator
    When I add "admin" to the participants
    Then I see that the number of participants shown in the list is "3"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "talk-user0" is shown in the list of participants as a moderator
    And I see that "admin" is shown in the list of participants as a normal participant

  Scenario: add participant to a one-to-one conversation when the participant is already logged in
    Given I act as John
    And I am logged in
    And I have opened the Talk app
    And I act as Jane
    And I am logged in as the admin
    And I have opened the Talk app
    And I act as John
    And I create a one-to-one conversation with "talk-user0"
    And I see that the sidebar is open
    When I add "admin" to the participants
    Then I act as Jane
    And I see that the "user0, talk-user0" conversation is shown in the list

  Scenario: promote participant to moderator in a group conversation
    Given I am logged in
    And I have opened the Talk app
    And I create a group conversation
    And I see that the sidebar is open
    And I add "admin" to the participants
    And I see that the number of participants shown in the list is "2"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "admin" is shown in the list of participants as a normal participant
    When I promote "admin" to moderator
    Then I see that the number of participants shown in the list is "2"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "admin" is shown in the list of participants as a moderator

  Scenario: demote participant from moderator in a group conversation
    Given I am logged in
    And I have opened the Talk app
    And I create a group conversation
    And I see that the sidebar is open
    And I add "admin" to the participants
    And I promote "admin" to moderator
    And I see that the number of participants shown in the list is "2"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "admin" is shown in the list of participants as a moderator
    When I demote "admin" from moderator
    Then I see that the number of participants shown in the list is "2"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "admin" is shown in the list of participants as a normal participant

  Scenario: remove participant from a group conversation
    Given I am logged in
    And I have opened the Talk app
    And I create a group conversation
    And I see that the sidebar is open
    And I add "admin" to the participants
    And I see that the number of participants shown in the list is "2"
    And I see that "user0" is shown in the list of participants as a moderator
    And I see that "admin" is shown in the list of participants as a normal participant
    When I remove "admin" from the participants
    Then I see that the number of participants shown in the list is "1"
    And I see that "user0" is shown in the list of participants as a moderator

  Scenario: remove participant from a group conversation when the participant has the conversation open
    Given I act as John
    And I am logged in
    And I have opened the Talk app
    And I create a group conversation
    And I see that the sidebar is open
    And I add "admin" to the participants
    And I act as Jane
    And I am logged in as the admin
    And I have opened the Talk app
    And I open the "user0" conversation
    And I see that the "user0" conversation is active
    When I act as John
    And I remove "admin" from the participants
    Then I act as Jane
    And I see that the "user0" conversation is not shown in the list
    And I see that the "This conversation has ended" empty content message is shown in the main view
    And I see that the sidebar is closed
