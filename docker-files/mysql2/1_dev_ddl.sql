CREATE DATABASE weq_dev;
USE weq_dev;

DROP TABLE IF EXISTS `t_sales`;
CREATE TABLE `t_sales` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT '商品タイトル',
  `price` int(10) unsigned NOT NULL COMMENT '税抜き価格',
  `created_at` datetime NOT NULL COMMENT '登録日時',
  `updated_at` datetime NOT NULL COMMENT '更新日時',
  `deleted_at` datetime NOT NULL COMMENT '削除日時',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `t_sales` (`product_id`, `price`, `created_at`, `updated_at`) VALUES (
 '1', 400, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '1', 400, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '1', 400, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '4', 410, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '5', 420, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '5', 420, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '10', 580, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '10', 580, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '10', 580, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
), (
 '10', 580, '2019-07-22 11:55:28', '2019-07-22 11:55:28'
);
