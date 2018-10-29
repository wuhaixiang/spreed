Feature: search

  Background:
    Given user "participant1" exists
    Given user "participant2" exists
    Given user "participant3" exists

  Scenario: search my own message in a one to one room
    Given user "participant1" creates room "one-to-one room"
      | roomType | 1 |
      | invite   | participant2 |
    And user "participant2" sends message "My first message" to room "one-to-one room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | one-to-one room |
      | name | My first message |
      | actorType | users |
      | actorId | participant2 |

  Scenario: search a message of the other user in a one to one room
    Given user "participant1" creates room "one-to-one room"
      | roomType | 1 |
      | invite   | participant2 |
    And user "participant1" sends message "Other's first message" to room "one-to-one room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | one-to-one room |
      | name | Other's first message |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search a message in a one to one room not invited to
    Given user "participant1" creates room "one-to-one room"
      | roomType | 1 |
      | invite   | participant2 |
    And user "participant1" sends message "Other's first message" to room "one-to-one room" with 201
    When user "participant3" searches for "first" in chat messages
    Then the list of search results has "0" results



  Scenario: search my own message in a group room
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" adds "participant2" to room "group room" with 200
    And user "participant2" sends message "My first message" to room "group room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | group room |
      | name | My first message |
      | actorType | users |
      | actorId | participant2 |

  Scenario: search a message of another user in a group room
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" adds "participant2" to room "group room" with 200
    And user "participant1" sends message "Other's first message" to room "group room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | group room |
      | name | Other's first message |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search a message of another user in a group room sent before being invited to the room
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" sends message "Other's first message" to room "group room" with 201
    And user "participant1" adds "participant2" to room "group room" with 200
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | group room |
      | name | Other's first message |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search a message in a group room not invited to
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" adds "participant2" to room "group room" with 200
    And user "participant1" sends message "Other's first message" to room "group room" with 201
    When user "participant3" searches for "first" in chat messages
    Then the list of search results has "0" results



  Scenario: search my own message in a public room
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "participant2" sends message "My first message" to room "public room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | My first message |
      | actorType | users |
      | actorId | participant2 |

  Scenario: search a message of another other user in a public room
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "participant1" sends message "Other's first message" to room "public room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | Other's first message |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search a message of another other user in a public room sent before being invited to the room
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" sends message "Other's first message" to room "public room" with 201
    And user "participant1" adds "participant2" to room "public room" with 200
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | Other's first message |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search a message of a self-joined user in a public room
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "participant3" joins room "public room" with 200
    And user "participant3" sends message "Self-joined's first message" to room "public room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | Self-joined's first message |
      | actorType | users |
      | actorId | participant3 |

  Scenario: search a message of a guest user in a public room
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "guest" joins room "public room" with 200
    And user "guest" sends message "Guest's first message" to room "public room" with 201
    When user "participant2" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | Guest's first message |
      | actorType | guests |
      | actorId | guest |
      | actorDisplayName | |

  Scenario: search a message in a public room not invited but joined to
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "participant3" joins room "public room" with 200
    And user "participant1" sends message "Other's first message" to room "public room" with 201
    When user "participant3" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | Other's first message |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search a message in a public room not invited but joined to sent before joining to the room
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "participant1" sends message "Other's first message" to room "public room" with 201
    And user "participant3" joins room "public room" with 200
    When user "participant3" searches for "first" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | Other's first message |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search a message in a public room not invited nor joined to
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "participant1" sends message "Other's first message" to room "public room" with 201
    When user "participant3" searches for "first" in chat messages
    Then the list of search results has "0" results

  # The search endpoint is available only to logged in users, so no search for
  # guests.



  Scenario: search a system message
    # TODO

  Scenario: search a message with a mention
    # TODO

  Scenario: search a long message ellipsized on the right
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" sends message "A very verbose message that is meant to be used to test the ellipsized message returned when searching for long chat messages" to room "public room" with 201
    When user "participant1" searches for "verbose" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | A very verbose message that is meant to be used to test the ellipsized message returned when searching for long chat messages |
      | actorType | users |
      | actorId | participant1 |
      | relevantMessagePart | A very verbose message that is meant to… |

  Scenario: search a long message ellipsized on the left
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" sends message "A very verbose message that is meant to be used to test the ellipsized message returned when searching for long chat messages" to room "public room" with 201
    When user "participant1" searches for "searching" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | A very verbose message that is meant to be used to test the ellipsized message returned when searching for long chat messages |
      | actorType | users |
      | actorId | participant1 |
      | relevantMessagePart | …ssage returned when searching for long chat messages |

  Scenario: search a long message ellipsized on both ends
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    And user "participant1" sends message "A very verbose message that is meant to be used to test the ellipsized message returned when searching for long chat messages" to room "public room" with 201
    When user "participant1" searches for "ellipsized" in chat messages
    Then the list of search results has "1" results
    And search result "0" contains
      | room | public room |
      | name | A very verbose message that is meant to be used to test the ellipsized message returned when searching for long chat messages |
      | actorType | users |
      | actorId | participant1 |
      | relevantMessagePart | …t to be used to test the ellipsized message returned when se… |



  Scenario: search a long message with several matches
    # TODO



  Scenario: search several messages in a one to one room
    Given user "participant1" creates room "one-to-one room"
      | roomType | 1 |
      | invite   | participant2 |
    And user "participant2" sends message "My first message to be found" to room "one-to-one room" with 201
    And user "participant2" sends message "My second message should not be found" to room "one-to-one room" with 201
    And user "participant1" sends message "Other user's first message to be found" to room "one-to-one room" with 201
    And user "participant1" sends message "Other user's second message should not be found" to room "one-to-one room" with 201
    And user "participant2" sends message "My third message to be found" to room "one-to-one room" with 201
    When user "participant2" searches for "message to be found" in chat messages
    Then the list of search results has "3" results
    And search result "0" contains
      | room | one-to-one room |
      | name | My third message to be found |
      | actorType | users |
      | actorId | participant2 |
    And search result "1" contains
      | room | one-to-one room |
      | name | Other user's first message to be found |
      | actorType | users |
      | actorId | participant1 |
    And search result "2" contains
      | room | one-to-one room |
      | name | My first message to be found |
      | actorType | users |
      | actorId | participant2 |

  Scenario: search several messages in a group room
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" adds "participant2" to room "group room" with 200
    And user "participant1" adds "participant3" to room "group room" with 200
    And user "participant1" sends message "Other user's first message to be found" to room "group room" with 201
    And user "participant2" sends message "My first message should not be found" to room "group room" with 201
    And user "participant2" sends message "My second message to be found" to room "group room" with 201
    And user "participant1" sends message "Other user's second message should not be found" to room "group room" with 201
    And user "participant2" sends message "My third message to be found" to room "group room" with 201
    And user "participant3" sends message "Yet another user's first message to be found" to room "group room" with 201
    When user "participant2" searches for "message to be found" in chat messages
    Then the list of search results has "4" results
    And search result "0" contains
      | room | group room |
      | name | Yet another user's first message to be found |
      | actorType | users |
      | actorId | participant3 |
    And search result "1" contains
      | room | group room |
      | name | My third message to be found |
      | actorType | users |
      | actorId | participant2 |
    And search result "2" contains
      | room | group room |
      | name | My second message to be found |
      | actorType | users |
      | actorId | participant2 |
    And search result "3" contains
      | room | group room |
      | name | Other user's first message to be found |
      | actorType | users |
      | actorId | participant1 |

  Scenario: search several messages in a public room
    Given user "participant1" creates room "public room"
      | roomType | 3 |
    # TODO
    And user "participant1" adds "participant2" to room "public room" with 200
    And user "participant3" joins room "public room" with 200
    And user "guest" joins room "public room" with 200
    And user "participant1" sends message "Other user's first message should not be found" to room "public room" with 201
    And user "participant2" sends message "My first message should not be found" to room "public room" with 201
    And user "guest" sends message "Guest's first message to be found" to room "public room" with 201
    And user "participant2" sends message "My second message to be found" to room "public room" with 201
    And user "participant1" sends message "Other user's second message should not be found" to room "public room" with 201
    And user "participant2" sends message "My third message to be found" to room "public room" with 201
    And user "participant3" sends message "Self-joined user's first message should not be found" to room "public room" with 201
    And user "guest" sends message "Guest's second message should not be found" to room "public room" with 201
    And user "participant3" sends message "Self-joined user's second message to be found" to room "public room" with 201
    When user "participant2" searches for "message to be found" in chat messages
    Then the list of search results has "4" results
    And search result "0" contains
      | room | public room |
      | name | Self-joined user's second message to be found |
      | actorType | users |
      | actorId | participant3 |
    And search result "1" contains
      | room | public room |
      | name | My third message to be found |
      | actorType | users |
      | actorId | participant2 |
    And search result "2" contains
      | room | public room |
      | name | My second message to be found |
      | actorType | users |
      | actorId | participant2 |
    And search result "3" contains
      | room | public room |
      | name | Guest's first message to be found |
      | actorType | guests |
      | actorId | guest |
      | actorDisplayName | |



  Scenario: search several messages in several rooms
    # TODO
