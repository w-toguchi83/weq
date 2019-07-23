CREATE DATABASE weq_test;
USE weq_test;

DROP TABLE IF EXISTS `m_product`;
CREATE TABLE `m_product` (
  `id` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT '商品ID',
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '商品タイトル',
  `title_ruby` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '商品タイトルルビ',
  `volume` varchar(7) COLLATE utf8_unicode_ci NULL COMMENT '巻数など',
  `price` int(10) unsigned NOT NULL COMMENT '税抜き価格',
  `series_id` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'シリーズID',
  `created_at` datetime NOT NULL COMMENT '登録日時',
  `updated_at` datetime NOT NULL COMMENT '更新日時',
  `deleted_at` datetime NOT NULL COMMENT '削除日時',
  PRIMARY KEY (`id`),
  KEY `idx_series_id` (`series_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `m_product` VALUES(
 1, 'シリーズ1商品タイトル1', 'シリーズ1ショウヒンタイトル1', 1, 400, '1000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL
), (
 2, 'シリーズ1商品タイトル2', 'シリーズ1ショウヒンタイトル2', 2, 400, '1000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL
), (
 3, 'シリーズ1商品タイトル3', 'シリーズ1ショウヒンタイトル3', 3, 400, '1000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL
), (
 4, 'シリーズ1商品タイトル4', 'シリーズ1ショウヒンタイトル4', 4, 410, '1000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL
), (
 5, 'シリーズ1商品タイトル5', 'シリーズ1ショウヒンタイトル5', 5, 420, '1000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL
), (
 6, 'シリーズ2商品タイトル1', 'シリーズ2ショウヒンタイトル1', 1, 380, '2000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL
), (
 7, 'シリーズ2商品タイトル2', 'シリーズ2ショウヒンタイトル2', 2, 380, '2000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', '2019-07-22 10:30:43'
), (
 8, 'シリーズ3商品タイトル1', 'シリーズ3ショウヒンタイトル1', 1, 580, '3000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL
), (
 9, 'シリーズ3商品タイトル2', 'シリーズ3ショウヒンタイトル2', 2, 580, '3000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL 
), (
 10, 'シリーズ3商品タイトル3', 'シリーズ3ショウヒンタイトル3', 3, 580, '3000', '2019-07-22 10:30:43', '2019-07-22 10:30:43', NULL 
);

