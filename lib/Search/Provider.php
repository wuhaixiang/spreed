<?php
declare(strict_types=1);

/**
 * @copyright Copyright (c) 2018 Joas Schilling <coding@schilljs.com>
 * @copyright Copyright (c) 2018 Daniel Calviño Sánchez <danxuliu@gmail.com>
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

namespace OCA\Spreed\Search;

use OCP\Comments\IComment;
use OCP\Files\Folder;
use OCP\Files\Node;
use OCP\IUser;

class Provider extends \OCP\Search\Provider {

	/**
	 * Search for $query
	 *
	 * @param string $query
	 * @return array An array of OCP\Search\Result's
	 * @since 7.0.0
	 */
	public function search($query): array {
		$cm = \OC::$server->getCommentsManager();
		$us = \OC::$server->getUserSession();

		$user = $us->getUser();
		if (!$user instanceof IUser) {
			return [];
		}
		$uf = \OC::$server->getUserFolder($user->getUID());

		if ($uf === null) {
			return [];
		}

		$l = \OC::$server->getL10N('spreed');

// 		$guestNames = !empty($guestSessions) ? $this->guestManager->getNamesBySessionHashes($guestSessions) : [];
		$userManager = \OC::$server->getUserManager();

		$manager = \OC::$server->resolve('OCA\Spreed\Manager');

		$result = [];
		$numComments = 50;
		$offset = 0;

		while (\count($result) < $numComments) {
			/** @var IComment[] $comments */
			$comments = $cm->search($query, 'chat', '', '', $offset, $numComments);

			foreach ($comments as $comment) {
				// TODO Handle guests, prevent access to rooms not joined to
				// TODO Ignore system messages
				if ($comment->getActorType() !== 'users' && $comment->getActorType() !== 'guests') {
					continue;
				}

				$room = $manager->getRoomById($comment->getObjectId());

				$actorDisplayName = '';
				if ($comment->getActorType() === 'users') {
					$user = $userManager->get($comment->getActorId());
					$actorDisplayName = $user instanceof IUser ? $user->getDisplayName() : '';
// 				} else if ($comment->getActorType() === 'guests' && isset($guestNames[$comment->getActorId()])) {
// 					$actorDisplayName = $guestNames[$comment->getActorId()];
				}

// 				$actorDisplayName = $cm->resolveDisplayName($comment->getActorType(), $comment->getActorId());

				try {
					$result[] = new Result(
						$l,
						$query,
						$comment,
						$room->getToken(),
						$actorDisplayName
					);
				} catch (\InvalidArgumentException $e) {
					continue;
				}
			}

			if (\count($comments) < $numComments) {
				// Didn't find more comments when we tried to get, so there are no more comments.
				return $result;
			}

			$offset += $numComments;
			$numComments = 50 - \count($result);
		}

		// TODO set guest names here

		return $result;
	}

}
