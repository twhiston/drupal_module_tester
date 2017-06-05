<?php
/**
 * Created by PhpStorm.
 * User: twhiston
 * Date: 05.06.17
 * Time: 17:30
 */

namespace Drupal\Tests\dmt_tester\Unit;

use Drupal\Tests\UnitTestCase;

/**
 * Class UnitTestTest
 *
 * @group dmt_tester
 */
class BasicUnitTest extends UnitTestCase {

  /**
   * If we can run this test then unit tests work in our container. Nice!
   */
  public function testNothing(){
    $this->assertTrue(TRUE);
  }

}