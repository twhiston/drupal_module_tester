<?php
/**
 * Created by PhpStorm.
 * User: twhiston
 * Date: 05.06.17
 * Time: 17:30
 */

namespace Drupal\Tests\dmt_tester\Functional;

use Drupal\Tests\BrowserTestBase;

/**
 * Class FunctionalTestTest
 *
 * @group dmt_tester
 */
class FunctionalTestTest extends BrowserTestBase {

  /**
   * If we have access to something in the container then hooray! Our kernel was booted properly
   */
  public function testFunctional() {

    $this->drupalGet('');
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->pageTextContains('Log in');
    $account = $this->drupalCreateUser();
    $this->drupalLogin($account);
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->pageTextContains('Member for');

  }

}