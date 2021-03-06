<?php
declare(strict_types=1);

/**
 *
 * @copyright Copyright (c) 2018, Daniel Calviño Sánchez (danxuliu@gmail.com)
 *
 * @license GNU AGPL version 3 or any later version
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace OCA\Spreed\PublicShareAuth;

use OCP\Share\IShare;
use OCP\Util;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\EventDispatcher\GenericEvent;

/**
 * Helper class to extend the "publicshareauth" template from the server.
 *
 * The "loadRequestPasswordByTalkUi" method loads additional scripts that, when
 * run on the browser, adjust the page generated by the server to inject the
 * Talk UI as needed.
 */
class TemplateLoader {

	/** @var EventDispatcherInterface */
	protected $dispatcher;

	public function __construct(EventDispatcherInterface $dispatcher) {
		$this->dispatcher = $dispatcher;
	}

	public function register() {
		$listener = function(GenericEvent $event) {
			/** @var IShare $share */
			$share = $event->getArgument('share');
			$this->loadRequestPasswordByTalkUi($share);
		};
		$this->dispatcher->addListener('OCA\Files_Sharing::loadAdditionalScripts::publicShareAuth', $listener);
	}

	/**
	 * Load the "Request password by Talk" UI in the public share authentication
	 * page for the given share.
	 *
	 * If the "Send Password by Talk" option is not set in the share then no UI
	 * to request the password is provided.
	 *
	 * This method should be called when loading additional scripts for the
	 * public share authentication page of the server.
	 *
	 * @param IShare $share
	 */
	public function loadRequestPasswordByTalkUi(IShare $share) {
		if (!$share->getSendPasswordByTalk()) {
			return;
		}

		Util::addStyle('spreed', 'publicshareauth');
		Util::addStyle('spreed', 'style');
		Util::addStyle('spreed', 'comments');
		Util::addStyle('spreed', 'autocomplete');

		Util::addScript('spreed', 'vendor/backbone/backbone-min');
		Util::addScript('spreed', 'vendor/backbone.radio/build/backbone.radio.min');
		Util::addScript('spreed', 'vendor/backbone.marionette/lib/backbone.marionette.min');
		Util::addScript('spreed', 'vendor/jshashes/hashes.min');
		Util::addScript('spreed', 'vendor/Caret.js/dist/jquery.caret.min');
		Util::addScript('spreed', 'vendor/At.js/dist/js/jquery.atwho.min');
		Util::addScript('spreed', 'models/chatmessage');
		Util::addScript('spreed', 'models/chatmessagecollection');
		Util::addScript('spreed', 'models/localstoragemodel');
		Util::addScript('spreed', 'models/room');
		Util::addScript('spreed', 'models/roomcollection');
		Util::addScript('spreed', 'models/participant');
		Util::addScript('spreed', 'models/participantcollection');
		Util::addScript('spreed', 'views/callinfoview');
		Util::addScript('spreed', 'views/chatview');
		Util::addScript('spreed', 'views/editabletextlabel');
		Util::addScript('spreed', 'views/participantlistview');
		Util::addScript('spreed', 'views/participantview');
		Util::addScript('spreed', 'views/roomlistview');
		Util::addScript('spreed', 'views/sidebarview');
		Util::addScript('spreed', 'views/tabview');
		Util::addScript('spreed', 'richobjectstringparser');
		Util::addScript('spreed', 'simplewebrtc');
		Util::addScript('spreed', 'webrtc');
		Util::addScript('spreed', 'signaling');
		Util::addScript('spreed', 'connection');
		Util::addScript('spreed', 'app');
		Util::addScript('spreed', 'publicshareauth');
	}

}
