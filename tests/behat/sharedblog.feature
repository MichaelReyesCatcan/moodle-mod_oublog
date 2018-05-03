@ou @ou_vle @mod @mod_oublog @oublog_sharedblog
Feature: Test shared data from Master blog on OUBlog
  In order to use OUBlog features
  As a user
  I need to be able to have a learning log with the same functionality as the master blog

  Background:
    Given the following "courses" exist:
      | fullname | shortname | format      | category | numsections |
      | Course 1 | C1        | oustudyplan | 0        | 0           |
      | Course 2 | C2        | oustudyplan | 0        | 0           |
    # Create masterblog.
    And the following "activities" exist:
      | activity | name        | intro                                  | course | idnumber   |
      | oublog   | Master Blog | A blog can share content to other blog | C1     | masterblog |
    # Create child blog.
    And the following "activities" exist:
      | activity | name       | intro                          | course | individual | idsharedblog | idnumber  |
      | oublog   | Child Blog | A blog get content from master | C1     | 2          | masterblog   | childblog |
    And the following "users" exist:
      | username | firstname | lastname | email            |
      | student1 | Student   | 1        | student@asd.com  |
      | student2 | Student   | 2        | student2@asd.com |
    And the following "course enrolments" exist:
      | user     | course | role    |
      | student1 | C1     | student |
      | student2 | C2     | student |
    And I log in as "admin"
    And I am on site homepage
    And I am on "Course 1" course homepage with editing mode on
    And I follow "Master Blog"
    And I press "New blog post"
    And I set the following fields to these values:
      | Title      | Content Master Blog 1               |
      | Message    | This is Content Master Blog 1       |
      | Tags       | master, blog                        |
      | Attachment | lib/tests/fixtures/upload_users.csv |
    And I press "Add post"

  @javascript
  Scenario: Child blog only show data relating to master blog
    When I am on homepage
    And I am on "Course 1" course homepage
    And I follow "Master Blog"
    And I click on "Add your comment" "link" in the ".oublog-post-links" "css_element"
    And I set the following fields to these values:
      | Title            | Comment post 1                 |
      | Add your comment | This is comment in master blog |
    And I press "id_submitbutton"
    And I am on "Course 1" course homepage
    And I follow "Child Blog"
    Then I should see "Content Master Blog 1"
    And I should see "upload_users.csv"
    And I should see "blog(1)" in the "#oublog-tags" "css_element"
    And I should see "1 comment" in the ".oublog-post-links" "css_element"
    And I should see "1 posts" in the ".oublog_statsview_content_myparticipation" "css_element"
    # View participation.
    And I should see "Content Master Blog 1" in the ".oublog_statsview_content_myparticipation" "css_element"
    And I should see "Comment post 1" in the ".oublog_statsview_content_myparticipation" "css_element"
    When I click on "View my participation" "link" in the ".oublog_statsview_content_myparticipation" "css_element"
    Then I should see "1 Posts" in the ".nav-tabs" "css_element"
    And I should see "Child Blog"
    And I should see "1 Comments" in the ".nav-tabs" "css_element"
    And I should see "Content Master Blog 1" in the "h3.oublog-post-title" "css_element"
    And I click on "1 Comments" "link" in the ".nav-tabs" "css_element"
    And I should see "Comment post 1" in the ".oublog-comment" "css_element"
    When I click on "Content Master Blog 1" "link"
    # We should be in shared blog when click on posts link
    Then I should see "Child Blog"
    And I should see "Content Master Blog 1"
    And I should see "Comment post 1"
    And I follow "Child Blog"
    And I click on "View my participation" "link" in the ".oublog_statsview_content_myparticipation" "css_element"
    And I click on "1 Comments" "link" in the ".nav-tabs" "css_element"
    When I click on "Content Master Blog 1" "link"
    # We should be in shared blog when click on comment link
    Then I should see "Child Blog"
    And I should see "Content Master Blog 1"
    And I should see "Comment post 1"
    And I follow "Child Blog"
    And I click on "Participation" "text" in the ".oublog-accordion-view" "css_element"
    Then I should see "Content Master Blog 1" in the ".oublog_statsview_content_participation" "css_element"
    And I should see "Comment post 1" in the ".oublog_statsview_content_participation" "css_element"
    And I click on "View all participation" "link" in the ".oublog_statsview_content_participation" "css_element"
    Then I should see "Admin User" in the ".cell.c0" "css_element"
    And I should see "Content Master Blog 1" in the ".cell.c1" "css_element"
    When I click on "Content Master Blog 1" "link"
    Then I should see "Child Blog"
    And I should see "Content Master Blog 1"
    And I should see "Comment post 1"
    And I follow "Child Blog"
    And I click on "View all participation" "link" in the ".oublog_statsview_content_participation" "css_element"
    And I click on "1 Comments" "link" in the ".nav-tabs" "css_element"
    Then I should see "Admin User" in the ".cell.c0" "css_element"
    And I should see "Comment post 1" in the ".cell.c1" "css_element"
    When I click on ".arrow_link" "css_element"
    And I navigate to "Edit settings" in current page administration
    And I expand all fieldsets
    And I set the following fields to these values:
      | Show blog usage extra statistics | 1 |
    And I press "id_submitbutton"
    And I should not see "Most posts" in the "#oublog-discover" "css_element"
    # Set setting of masterblog that allow to show Most posts on Blog usage.
    Then I am on "Course 1" course homepage
    And I follow "Master Blog"
    And I navigate to "Edit settings" in current page administration
    And I expand all fieldsets
    And I set the following fields to these values:
      | Show blog usage extra statistics | 1 |
      | Individual blogs                 | 2 |
    And I press "id_submitbutton"
    Then I am on "Course 1" course homepage
    And I follow "Child Blog"
    And I should see "Most posts" in the "#oublog-discover" "css_element"
    And I click on "Most posts" "text" in the ".oublog-accordion-view" "css_element"
    And I should see "1 posts" in the ".oublog_statsinfo_bar" "css_element"

  @javascript
  Scenario: Child blog show links from master blog
    When I am on homepage
    And I am on "Course 1" course homepage
    And I follow "Master Blog"
    And I follow "Add link"
    And I set the following fields to these values:
      | Title            | Teachers Personal blog test                 |
      | Full Web address | http://127.0.0.1/mod/oublog/view.php?user=3 |
    And I press "id_submitbutton"
    And I am on "Course 1" course homepage
    And I follow "Child Blog"
    And I should see "Teachers Personal blog test" in the "#oublog-links" "css_element"

  @javascript
  Scenario: Fail to create child blog because wrong ID number.
    When I am on "Course 1" course homepage
    And I add a "OU blog" to section "0" and I fill the form with:
      | Blog name        | Child Blog 2             |
      | Intro            | Can not create this blog |
      | Individual blogs | Visible individual blogs |
      | Shared blog      | masterblog2              |
    Then I press "Save and display"
    And I should see "No matching ID number"

  @javascript
  Scenario: Fail to create child blog because that blog is child of the other.
    When I am on "Course 1" course homepage
    And I add a "OU blog" to section "0" and I fill the form with:
      | Blog name        | Child Blog 3             |
      | Intro            | Can not create this blog |
      | Individual blogs | Visible individual blogs |
      | Shared blog      | childblog                |
    Then I press "Save and display"
    And I should see "This is an ID number of a child blog"

  @javascript
  Scenario: Checking posts action in shared blog
    Given the following "activities" exist:
      | activity | name         | intro                                              | course | individual | idsharedblog | idnumber   |
      | oublog   | Child Blog 2 | A blog get content from master on different course | C2     | 2          | masterblog   | childblog2 |
    And I am on site homepage
    And I set the following administration settings values:
      | enableportfolios | 1 |
    And I navigate to "Manage portfolios" node in "Site administration > Plugin > Portfolios"
    And I set the field with xpath "//form[@id='applytodownload']/select" to "Enabled and visible"
    And I press "Save"
    And I am on "Course 1" course homepage
    And I follow "Child Blog"
    Then I should see "Content Master Blog 1"
    And I log out
    Given I log in as "student1"
    And I am on "Course 1" course homepage
    And I press "Expand all"
    And I follow "Child Blog"
    Then I should see "Content Master Blog 1"
    When I press "New blog post"
    And I set the following fields to these values:
      | Title   | P1            |
      | Message | P1 of student |
      | Tags    | blog,child    |
    And I press "Add post"
    # Add new post in child should redirect to child blog.
    Then I should see "Child Blog"
    And I should see "P1 of student"
    And I should see "blog(2) child(1) master(1)"
    And I follow "Edit"
    And I set the following fields to these values:
      | Title   | P1 edited            |
      | Message | P1 of student edited |
      | Tags    | edited,child         |
    And I press "Save changes"
    # Edit a post should redirect to child blog
    Then I should see "Child Blog"
    And I should see "P1 of student edited"
    And I should see "blog(1) child(1) edited(1) master(1)"
    And I follow "Add your comment"
    And I set the following fields to these values:
      | Title            | Comment P1 |
      | Add your comment | Comment P1 |
    And I press "Add comment"
    Then I should see "Child Blog"
    # Add comment in view page should redirect to view page
    And I should see "1 comment"
    And I follow "1 comment"
    And I should see "Comment P1"
    When I click on "Delete" "link" in the "#oublogcomments" "css_element"
    Then I should see "Are you sure you want to delete this comment?"
    And I press "Continue"
    # Delete a comment in view a post should redirect to view post.
    And I should not see "Comment P1"
    And I should see "P1 of student edited"
    And I should see "Child Blog"
    When I click on "Delete" "link" in the ".oublog-post-bottom" "css_element"
    Then I should see "Are you sure you want to delete this post?"
    And I press "Delete"
    # Delete a post should return to child blog.
    Then I should see "Child Blog"
    And I should see "blog(1) master(1)"
    # Delete a post without comment
    When I press "New blog post"
    And I set the following fields to these values:
      | Title   | P2            |
      | Message | P2 of student |
    And I press "Add post"
    Then  I should see "P2 of student"
    And I follow "Delete"
    Then I should see "Are you sure you want to delete this post?"
    And I press "Delete"
    # Check permanent link.
    When I press "New blog post"
    And I set the following fields to these values:
      | Title   | P3            |
      | Message | P3 of student |
    And I press "Add post"
    Then  I should see "P3 of student"
    And I follow "Permalink"
    And I follow "Add your comment"
    # We should check breadcrumb link to make sure we still in shared blog
    When I click on "P3" "link" in the ".breadcrumb-nav" "css_element"
    Then I should see "Child Blog"
    And I follow "Add your comment"
    And I set the following fields to these values:
      | Title            | Comment P3 |
      | Add your comment | Comment P3 |
    And I press "Add comment"
    Then I should see "P3 of student"
    And I should see "Comment P3"
    And I should see "Child Blog"
    # Check export
    And I am on "Course 1" course homepage
    And I follow "Child Blog"
    # Export should have some files,so the file must be large.
    Then following "Export" should download between "10000" and "100000" bytes
    And I log out
    # Shared blog in different course.
    Given I log in as "student2"
    And I am on "Course 2" course homepage
    And I press "Expand all"
    And I follow "Child Blog 2"
    Then I should see "Content Master Blog 1"
    And I should see "P3 of student"
    When I press "New blog post"
    And I set the following fields to these values:
      | Title      | P1 of student in different course   |
      | Message    | P1 of student in different course   |
      | Tags       | different                           |
      | Attachment | lib/tests/fixtures/upload_users.csv |
    And I press "Add post"
    Then I should see "Child Blog 2"
    And I should see "P1 of student in different course"
    And I should see "blog(1) different(1) master(1)"
    And I follow "Edit"
    And I set the following fields to these values:
      | Title   | P1 of student in different course        |
      | Message | P1 of student in different course edited |
      | Tags    | differentedited                          |
    And I press "Save changes"
    Then I should see "P1 of student in different course edited"
    And I should see "blog(1) differentedited(1) master(1)"
    And I follow "Permalink"
    And I follow "Edited by Student 2"
    # We should check breadcrumb link to make sure we still in shared blog
    When I click on "P1 of student in different course" "link" in the ".breadcrumb-nav" "css_element"
    Then I should see "Child Blog"
    And I follow "Edited by Student 2"
    Then I should see "P1 of student in different course"
    Then following "upload_users.csv" should download between "100" and "100000" bytes
    And I log out
    # Test add link
    Given I log in as "admin"
    And I am on "Course 2" course homepage with editing mode on
    And I follow "Child Blog 2"
    Given I follow "Add link"
    And I set the following fields to these values:
      | Title            | Teachers Personal blog test                 |
      | Full Web address | http://127.0.0.1/mod/oublog/view.php?user=3 |
    When I press "id_submitbutton"
    Then I should see "Child Blog 2"
    When I am on "Course 1" course homepage
    And I follow "Master Blog"
    Then I should see "P1 of student in different course"
    Then following "upload_users.csv" should download between "100" and "100000" bytes

  @javascript
  Scenario: Activity settings should be independent.
    Given the following "activities" exist:
      | activity | name       | intro                          | course | individual | idsharedblog | idnumber  |
      | oublog   | Child Blog | A blog get content from master | C1     | 2          | masterblog   | childblog |
    When I am on "Course 1" course homepage
    And I add a "OU blog" to section "0" and I fill the form with:
      | Blog name                           | Child Blog 3             |
      | Intro                               | Can not create this blog |
      | Individual blogs                    | Visible individual blogs |
      | Allow comments (if chosen for post) | Comments not allowed     |
      | Shared blog                         | masterblog               |
    And I follow "Master Blog"
    And I click on "Add your comment" "link" in the ".oublog-post-links" "css_element"
    And I set the following fields to these values:
      | Title            | Comment post 1                 |
      | Add your comment | This is comment in master blog |
    And I press "id_submitbutton"
    And I am on "Course 1" course homepage
    # Allow comment in setting.
    And I follow "Child Blog"
    Then I should see "Content Master Blog 1"
    And I should see "1 comment" in the ".oublog-post-links" "css_element"
    And I should see "Participation" in the ".oublog-accordion" "css_element"
    And I should see "Most commented posts" in the ".oublog-accordion " "css_element"
    # Not allow comment in setting.
    When I am on "Course 1" course homepage
    And I follow "Child Blog 3"
    Then I should see "Content Master Blog 1"
    And I should not see "1 comment" in the ".oublog-post-links" "css_element"
    And I should not see "Participation" in the ".oublog-accordion " "css_element"
    And I should not see "Most commented posts" in the ".oublog-accordion " "css_element"
