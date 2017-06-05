<?php
/**
 * Created by PhpStorm.
 * User: twhiston
 * Date: 05.06.17
 * Time: 17:30
 */

namespace Drupal\Tests\dmt_tester\Kernel;

use Drupal\KernelTests\KernelTestBase;

/**
 * Class KernelTestTest
 *
 * @group dmt_tester
 */
class KernelTestTest extends KernelTestBase {

  /**
   * If we have access to something in the container then hooray! Our kernel was booted properly
   */
  public function testKernelIsBootstrappe() {
    $logger = \Drupal::getContainer()->get('logger.factory');
    $impl = class_implements($logger);
    if (in_array('Drupal\Core\Logger\LoggerChannelFactoryInterface', $impl)) {
      $this->assertTrue(TRUE);
      return;
    }
    $this->assertTrue(FALSE);
  }

}