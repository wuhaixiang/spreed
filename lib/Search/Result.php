<?php
/**
 * @copyright Copyright (c) 2018 Joas Schilling <coding@schilljs.com>
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
use OCP\Files\NotFoundException;
use OCP\Search\Result as BaseResult;

class Result extends BaseResult {

	public $type = 'chat';
	public $comment;
	public $authorId;
	public $authorName;

	/**
	 * @param string $search
	 * @param IComment $comment
	 * @param string $authorName
	 * @param string $path
	 * @throws NotFoundException
	 */
	public function __construct(string $search,
								IComment $comment,
								string $authorName) {
		parent::__construct(
			(int) $comment->getId(),
			$comment->getMessage()
		/* @todo , [link to file] */
		);
		// TODO provide the room token and message id and generate the link in
		// the client? In any case, needs to open the chat exactly in that
		// message.

		$this->comment = $this->getRelevantMessagePart($comment->getMessage(), $search);
		$this->authorId = $comment->getActorId();
		$this->authorName = $authorName;
	}

	/**
	 * @param string $message
	 * @param string $search
	 * @return string
	 * @throws NotFoundException
	 */
	protected function getRelevantMessagePart(string $message, string $search): string {
		$start = stripos($message, $search);
		if ($start === false) {
			throw new NotFoundException('Chat message section not found');
		}

		$end = $start + strlen($search);

		if ($start <= 25) {
			$start = 0;
			$prefix = '';
		} else {
			$start -= 25;
			$prefix = '…';
		}

		if ((strlen($message) - $end) <= 25) {
			$end = strlen($message);
			$suffix = '';
		} else {
			$end += 25;
			$suffix = '…';
		}

		return $prefix . substr($message, $start, $end - $start) . $suffix;
	}

}
