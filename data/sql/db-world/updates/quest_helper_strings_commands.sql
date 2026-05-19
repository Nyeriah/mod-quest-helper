-- mod-quest-helper: module strings and command table
-- Includes strings and commands for .qh info and .qh addtemp (added 2026-05-17)

DELETE FROM `module_string`        WHERE `module` = 'mod-quest-helper';
DELETE FROM `module_string_locale` WHERE `module` = 'mod-quest-helper';

INSERT INTO `module_string` (`module`, `id`, `string`) VALUES
-- Player notifications (coloured green)
('mod-quest-helper',  1, '|cff4CFF00Time travellers, we are aware of issues affecting ''{}''. The quest will complete automatically while we work on a fix.|r'),
('mod-quest-helper',  2, '|cff4CFF00Time travellers, we are aware of issues affecting ''{}''. The quest will complete and rewards will be granted automatically while we work on a fix.|r'),
('mod-quest-helper',  3, '|cff4CFF00[Quest Helper] This server automatically notifies you when you accept a quest with a known issue, so you are never left in the dark. Type .qh off to disable these messages.|r'),
-- Quest-accept comment (coloured blue)
('mod-quest-helper', 11, '|cff00BFFF[Quest Note] {}|r'),
-- Command confirmations (no colour)
('mod-quest-helper',  4, 'Quest Helper notifications are now enabled.'),
('mod-quest-helper',  5, 'Quest Helper notifications are now disabled.'),
('mod-quest-helper',  8, 'Quest {} ("{}", flag {}) added for realm {}.'),
('mod-quest-helper', 10, 'Quest {} ("{}") [flag {}] removed from realm {}.'),
('mod-quest-helper', 12, 'Comment (ID: {}) added to quest {} ("{}") on realm {}.'),
('mod-quest-helper', 14, 'Comment {} removed.'),
('mod-quest-helper', 15, 'Comment {} is now hidden.'),
-- Reload confirmation (no colour)
('mod-quest-helper', 16, 'Quest Helper data reloaded.'),
-- Command errors (no colour)
('mod-quest-helper',  6, 'Quest {} not found.'),
('mod-quest-helper',  7, 'Invalid flag. Use 1 (auto-complete) or 2 (auto-complete and reward).'),
('mod-quest-helper',  9, 'Quest {} ("{}") is not registered for realm {}.'),
('mod-quest-helper', 23, 'Quest {} ("{}") is already registered on realm {} with flag {}. No changes made.'),
('mod-quest-helper', 24, 'Quest {} ("{}") on realm {}: flag updated from {} to {}.');
('mod-quest-helper', 13, 'Comment ID {} not found.'),
-- .qh info: not flagged
('mod-quest-helper', 17, 'Quest {} ("{}") has no known issues registered on realm {}.'),
-- .qh info: flagged (auto-complete only)
('mod-quest-helper', 18, '|cff4CFF00Quest {} ("{}") is flagged for auto-complete on realm {}.|r'),
-- .qh info: flagged (auto-complete + reward)
('mod-quest-helper', 19, '|cff4CFF00Quest {} ("{}") is flagged for auto-complete with reward on realm {}.|r'),
-- .qh info: until-restart indicator
('mod-quest-helper', 20, '|cffFF8C00  This flag is temporary and will be removed on the next restart.|r'),
-- .qh info: reason line
('mod-quest-helper', 21, '  Reason: {}'),
-- .qh addtemp: GM confirmation
('mod-quest-helper', 22, 'Quest {} ("{}", flag {}) added for realm {} (expires on next restart).');

INSERT INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
-- koKR
('mod-quest-helper', 16, 'koKR', '퀘스트 도우미 데이터가 다시 로드되었습니다.'),
('mod-quest-helper',  1, 'koKR', '|cff4CFF00"{}\" 퀘스트의 문제를 인지하고 있습니다. 퀘스트가 자동으로 완료될 것입니다.|r'),
('mod-quest-helper',  2, 'koKR', '|cff4CFF00"{}\" 퀘스트의 문제를 인지하고 있습니다. 퀘스트가 자동으로 완료되고 보상이 지급될 것입니다.|r'),
('mod-quest-helper',  3, 'koKR', '|cff4CFF00[퀘스트 도우미] 이 서버는 알려진 문제가 있는 퀘스트를 수락할 때 자동으로 알려드립니다. 알림을 비활성화하려면 .qh off 를 입력하세요.|r'),
('mod-quest-helper', 11, 'koKR', '|cff00BFFF[퀘스트 안내] {}|r'),
('mod-quest-helper',  4, 'koKR', '퀘스트 도우미 알림이 활성화되었습니다.'),
('mod-quest-helper',  5, 'koKR', '퀘스트 도우미 알림이 비활성화되었습니다.'),
('mod-quest-helper',  8, 'koKR', '퀘스트 {} ("{}", 플래그 {})가 렐름 {}에 추가되었습니다.'),
('mod-quest-helper', 10, 'koKR', '퀘스트 {} ("{}") [플래그 {}]이(가) 렐름 {}에서 제거되었습니다.'),
('mod-quest-helper', 12, 'koKR', '댓글 (ID: {})이(가) 렐름 {}의 퀘스트 {} ("{}")에 추가되었습니다.'),
('mod-quest-helper', 14, 'koKR', '댓글 {}이(가) 삭제되었습니다.'),
('mod-quest-helper', 15, 'koKR', '댓글 {}이(가) 숨겨졌습니다.'),
('mod-quest-helper',  6, 'koKR', '퀘스트 {}를 찾을 수 없습니다.'),
('mod-quest-helper',  7, 'koKR', '잘못된 플래그입니다. 1(자동 완료) 또는 2(자동 완료 및 보상)를 사용하세요.'),
('mod-quest-helper',  9, 'koKR', '퀘스트 {} ("{}")은(는) 렐름 {}에 등록되어 있지 않습니다.'),
('mod-quest-helper', 23, 'koKR', '퀘스트 {} ("{}")은(는) 이미 렐름 {}에 플래그 {}로 등록되어 있습니다. 변경 사항 없음.'),
('mod-quest-helper', 24, 'koKR', '퀘스트 {} ("{}") 렐름 {}: 플래그가 {}에서 {}로 업데이트되었습니다.'),
('mod-quest-helper', 13, 'koKR', '댓글 ID {}를 찾을 수 없습니다.'),
-- frFR
('mod-quest-helper', 16, 'frFR', 'Données de l''Assistant de Quête rechargées.'),
('mod-quest-helper',  1, 'frFR', '|cff4CFF00Nous sommes conscients des problèmes liés à la quête "{}". Elle sera automatiquement complétée.|r'),
('mod-quest-helper',  2, 'frFR', '|cff4CFF00Nous sommes conscients des problèmes liés à la quête "{}". Elle sera automatiquement complétée et récompensée.|r'),
('mod-quest-helper',  3, 'frFR', '|cff4CFF00[Assistant de Quête] Ce serveur vous avertit automatiquement lorsque vous acceptez une quête avec un problème connu, pour que vous ne soyez jamais pris au dépourvu. Tapez .qh off pour désactiver ces messages.|r'),
('mod-quest-helper', 11, 'frFR', '|cff00BFFF[Note de quête] {}|r'),
('mod-quest-helper',  4, 'frFR', 'Les notifications de l''Assistant de Quête sont maintenant activées.'),
('mod-quest-helper',  5, 'frFR', 'Les notifications de l''Assistant de Quête sont maintenant désactivées.'),
('mod-quest-helper',  8, 'frFR', 'Quête {} ("{}", indicateur {}) ajoutée pour le royaume {}.'),
('mod-quest-helper', 10, 'frFR', 'Quête {} ("{}") [indicateur {}] retirée du royaume {}.'),
('mod-quest-helper', 12, 'frFR', 'Commentaire (ID : {}) ajouté à la quête {} ("{}") sur le royaume {}.'),
('mod-quest-helper', 14, 'frFR', 'Commentaire {} supprimé.'),
('mod-quest-helper', 15, 'frFR', 'Commentaire {} masqué.'),
('mod-quest-helper',  6, 'frFR', 'Quête {} introuvable.'),
('mod-quest-helper',  7, 'frFR', 'Indicateur invalide. Utilisez 1 (complétion auto) ou 2 (complétion auto et récompense).'),
('mod-quest-helper',  9, 'frFR', 'La quête {} ("{}") n''est pas enregistrée pour le royaume {}.'),
('mod-quest-helper', 23, 'frFR', 'La quête {} ("{}") est déjà enregistrée sur le royaume {} avec l''indicateur {}. Aucune modification.'),
('mod-quest-helper', 24, 'frFR', 'Quête {} ("{}") sur le royaume {} : indicateur mis à jour de {} à {}.');
('mod-quest-helper', 13, 'frFR', 'ID de commentaire {} introuvable.'),
-- deDE
('mod-quest-helper', 16, 'deDE', 'Quest-Helfer-Daten neu geladen.'),
('mod-quest-helper',  1, 'deDE', '|cff4CFF00Wir sind uns der Probleme mit der Quest "{}" bewusst. Sie wird automatisch abgeschlossen.|r'),
('mod-quest-helper',  2, 'deDE', '|cff4CFF00Wir sind uns der Probleme mit der Quest "{}" bewusst. Sie wird automatisch abgeschlossen und belohnt.|r'),
('mod-quest-helper',  3, 'deDE', '|cff4CFF00[Quest-Helfer] Dieser Server benachrichtigt dich automatisch, wenn du eine Quest mit einem bekannten Problem annimmst, damit du nie im Dunkeln tappst. Tippe .qh off ein, um diese Nachrichten zu deaktivieren.|r'),
('mod-quest-helper', 11, 'deDE', '|cff00BFFF[Quest-Hinweis] {}|r'),
('mod-quest-helper',  4, 'deDE', 'Quest-Helfer-Benachrichtigungen sind jetzt aktiviert.'),
('mod-quest-helper',  5, 'deDE', 'Quest-Helfer-Benachrichtigungen sind jetzt deaktiviert.'),
('mod-quest-helper',  8, 'deDE', 'Quest {} ("{}", Flag {}) für Realm {} hinzugefügt.'),
('mod-quest-helper', 10, 'deDE', 'Quest {} ("{}") [Flag {}] aus Realm {} entfernt.'),
('mod-quest-helper', 12, 'deDE', 'Kommentar (ID: {}) zu Quest {} ("{}") auf Realm {} hinzugefügt.'),
('mod-quest-helper', 14, 'deDE', 'Kommentar {} entfernt.'),
('mod-quest-helper', 15, 'deDE', 'Kommentar {} ist jetzt ausgeblendet.'),
('mod-quest-helper',  6, 'deDE', 'Quest {} nicht gefunden.'),
('mod-quest-helper',  7, 'deDE', 'Ungültiges Flag. Verwende 1 (Auto-Abschluss) oder 2 (Auto-Abschluss und Belohnung).'),
('mod-quest-helper',  9, 'deDE', 'Quest {} ("{}") ist für Realm {} nicht registriert.'),
('mod-quest-helper', 23, 'deDE', 'Quest {} ("{}") ist bereits auf Realm {} mit Flag {} registriert. Keine Änderungen.'),
('mod-quest-helper', 24, 'deDE', 'Quest {} ("{}") auf Realm {}: Flag von {} auf {} aktualisiert.');
('mod-quest-helper', 13, 'deDE', 'Kommentar-ID {} nicht gefunden.'),
-- zhCN
('mod-quest-helper', 16, 'zhCN', '任务助手数据已重新加载。'),
('mod-quest-helper',  1, 'zhCN', '|cff4CFF00我们已知晓任务"{}"存在问题，该任务将自动完成。|r'),
('mod-quest-helper',  2, 'zhCN', '|cff4CFF00我们已知晓任务"{}"存在问题，该任务将自动完成并发放奖励。|r'),
('mod-quest-helper',  3, 'zhCN', '|cff4CFF00[任务助手] 当您接受存在已知问题的任务时，服务器将自动通知您，让您随时了解情况。输入 .qh off 可关闭这些提示。|r'),
('mod-quest-helper', 11, 'zhCN', '|cff00BFFF[任务提示] {}|r'),
('mod-quest-helper',  4, 'zhCN', '任务助手通知已启用。'),
('mod-quest-helper',  5, 'zhCN', '任务助手通知已禁用。'),
('mod-quest-helper',  8, 'zhCN', '任务 {} ("{}"，标志 {}) 已添加至领域 {}。'),
('mod-quest-helper', 10, 'zhCN', '任务 {} ("{}") [标志 {}] 已从领域 {} 中移除。'),
('mod-quest-helper', 12, 'zhCN', '备注（ID：{}）已添加至领域 {} 的任务 {} ("{}")。'),
('mod-quest-helper', 14, 'zhCN', '备注 {} 已删除。'),
('mod-quest-helper', 15, 'zhCN', '备注 {} 已隐藏。'),
('mod-quest-helper',  6, 'zhCN', '找不到任务 {}。'),
('mod-quest-helper',  7, 'zhCN', '无效的标志。请使用 1（自动完成）或 2（自动完成并发放奖励）。'),
('mod-quest-helper',  9, 'zhCN', '任务 {} ("{}") 未在领域 {} 中注册。'),
('mod-quest-helper', 23, 'zhCN', '任务 {} ("{}") 已在领域 {} 上以标志 {} 注册。无更改。'),
('mod-quest-helper', 24, 'zhCN', '任务 {} ("{}") 在领域 {} 上：标志从 {} 更新为 {}。');
('mod-quest-helper', 13, 'zhCN', '找不到备注 ID {}。'),
-- zhTW
('mod-quest-helper', 16, 'zhTW', '任務助手資料已重新載入。'),
('mod-quest-helper',  1, 'zhTW', '|cff4CFF00我們已知悉任務「{}」存在問題，該任務將自動完成。|r'),
('mod-quest-helper',  2, 'zhTW', '|cff4CFF00我們已知悉任務「{}」存在問題，該任務將自動完成並發放獎勵。|r'),
('mod-quest-helper',  3, 'zhTW', '|cff4CFF00[任務助手] 當您接受存在已知問題的任務時，伺服器將自動通知您，讓您隨時掌握情況。輸入 .qh off 可關閉這些提示。|r'),
('mod-quest-helper', 11, 'zhTW', '|cff00BFFF[任務提示] {}|r'),
('mod-quest-helper',  4, 'zhTW', '任務助手通知已啟用。'),
('mod-quest-helper',  5, 'zhTW', '任務助手通知已停用。'),
('mod-quest-helper',  8, 'zhTW', '任務 {} ("{}"，旗標 {}) 已新增至領域 {}。'),
('mod-quest-helper', 10, 'zhTW', '任務 {} ("{}") [旗標 {}] 已從領域 {} 中移除。'),
('mod-quest-helper', 12, 'zhTW', '備註（ID：{}）已新增至領域 {} 的任務 {} ("{}")。'),
('mod-quest-helper', 14, 'zhTW', '備註 {} 已移除。'),
('mod-quest-helper', 15, 'zhTW', '備註 {} 已隱藏。'),
('mod-quest-helper',  6, 'zhTW', '找不到任務 {}。'),
('mod-quest-helper',  7, 'zhTW', '無效的旗標。請使用 1（自動完成）或 2（自動完成並發放獎勵）。'),
('mod-quest-helper',  9, 'zhTW', '任務 {} ("{}") 未在領域 {} 中註冊。'),
('mod-quest-helper', 23, 'zhTW', '任務 {} ("{}") 已在領域 {} 上以旗標 {} 註冊。無更改。'),
('mod-quest-helper', 24, 'zhTW', '任務 {} ("{}") 在領域 {} 上：旗標從 {} 更新為 {}。');
('mod-quest-helper', 13, 'zhTW', '找不到備註 ID {}。'),
-- esES
('mod-quest-helper', 16, 'esES', 'Datos del Asistente de Misiones recargados.'),
('mod-quest-helper',  1, 'esES', '|cff4CFF00Somos conscientes de los problemas con la misión "{}". Se completará automáticamente.|r'),
('mod-quest-helper',  2, 'esES', '|cff4CFF00Somos conscientes de los problemas con la misión "{}". Se completará automáticamente y se otorgará la recompensa.|r'),
('mod-quest-helper',  3, 'esES', '|cff4CFF00[Asistente de Misiones] Este servidor te avisa automáticamente cuando aceptas una misión con un problema conocido, para que nunca te quedes sin saber qué pasa. Escribe .qh off para desactivar estos mensajes.|r'),
('mod-quest-helper', 11, 'esES', '|cff00BFFF[Nota de misión] {}|r'),
('mod-quest-helper',  4, 'esES', 'Las notificaciones del Asistente de Misiones están ahora activadas.'),
('mod-quest-helper',  5, 'esES', 'Las notificaciones del Asistente de Misiones están ahora desactivadas.'),
('mod-quest-helper',  8, 'esES', 'Misión {} ("{}", indicador {}) añadida para el reino {}.'),
('mod-quest-helper', 10, 'esES', 'Misión {} ("{}") [indicador {}] eliminada del reino {}.'),
('mod-quest-helper', 12, 'esES', 'Comentario (ID: {}) añadido a la misión {} ("{}") en el reino {}.'),
('mod-quest-helper', 14, 'esES', 'Comentario {} eliminado.'),
('mod-quest-helper', 15, 'esES', 'Comentario {} ocultado.'),
('mod-quest-helper',  6, 'esES', 'Misión {} no encontrada.'),
('mod-quest-helper',  7, 'esES', 'Indicador inválido. Usa 1 (auto-completar) o 2 (auto-completar y recompensar).'),
('mod-quest-helper',  9, 'esES', 'La misión {} ("{}") no está registrada para el reino {}.'),
('mod-quest-helper', 23, 'esES', 'La misión {} ("{}") ya está registrada en el reino {} con el indicador {}. Sin cambios.'),
('mod-quest-helper', 24, 'esES', 'Misión {} ("{}") en el reino {}: indicador actualizado de {} a {}.');
('mod-quest-helper', 13, 'esES', 'No se encontró el ID de comentario {}.'),
-- esMX
('mod-quest-helper', 16, 'esMX', 'Datos del Asistente de Misiones recargados.'),
('mod-quest-helper',  1, 'esMX', '|cff4CFF00Estamos al tanto de los problemas con la misión "{}". Se completará automáticamente.|r'),
('mod-quest-helper',  2, 'esMX', '|cff4CFF00Estamos al tanto de los problemas con la misión "{}". Se completará automáticamente y se otorgará la recompensa.|r'),
('mod-quest-helper',  3, 'esMX', '|cff4CFF00[Asistente de Misiones] Este servidor te notifica automáticamente cuando aceptas una misión con un problema conocido, para que siempre estés al tanto. Escribe .qh off para desactivar estos mensajes.|r'),
('mod-quest-helper', 11, 'esMX', '|cff00BFFF[Nota de misión] {}|r'),
('mod-quest-helper',  4, 'esMX', 'Las notificaciones del Asistente de Misiones están ahora activadas.'),
('mod-quest-helper',  5, 'esMX', 'Las notificaciones del Asistente de Misiones están ahora desactivadas.'),
('mod-quest-helper',  8, 'esMX', 'Misión {} ("{}", indicador {}) agregada para el reino {}.'),
('mod-quest-helper', 10, 'esMX', 'Misión {} ("{}") [indicador {}] eliminada del reino {}.'),
('mod-quest-helper', 12, 'esMX', 'Comentario (ID: {}) agregado a la misión {} ("{}") en el reino {}.'),
('mod-quest-helper', 14, 'esMX', 'Comentario {} eliminado.'),
('mod-quest-helper', 15, 'esMX', 'Comentario {} oculto.'),
('mod-quest-helper',  6, 'esMX', 'Misión {} no encontrada.'),
('mod-quest-helper',  7, 'esMX', 'Indicador inválido. Usa 1 (auto-completar) o 2 (auto-completar y recompensar).'),
('mod-quest-helper',  9, 'esMX', 'La misión {} ("{}") no está registrada para el reino {}.'),
('mod-quest-helper', 23, 'esMX', 'La misión {} ("{}") ya está registrada en el reino {} con el indicador {}. Sin cambios.'),
('mod-quest-helper', 24, 'esMX', 'Misión {} ("{}") en el reino {}: indicador actualizado de {} a {}.');
('mod-quest-helper', 13, 'esMX', 'No se encontró el ID de comentario {}.'),
-- ruRU
('mod-quest-helper', 16, 'ruRU', 'Данные помощника заданий перезагружены.'),
('mod-quest-helper',  1, 'ruRU', '|cff4CFF00Мы знаем о проблемах с заданием "{}". Оно будет выполнено автоматически.|r'),
('mod-quest-helper',  2, 'ruRU', '|cff4CFF00Мы знаем о проблемах с заданием "{}". Оно будет выполнено автоматически с выдачей награды.|r'),
('mod-quest-helper',  3, 'ruRU', '|cff4CFF00[Помощник заданий] Этот сервер автоматически уведомляет вас, когда вы берёте задание с известной проблемой, чтобы вы всегда были в курсе. Введите .qh off, чтобы отключить эти сообщения.|r'),
('mod-quest-helper', 11, 'ruRU', '|cff00BFFF[Заметка к заданию] {}|r'),
('mod-quest-helper',  4, 'ruRU', 'Уведомления помощника заданий включены.'),
('mod-quest-helper',  5, 'ruRU', 'Уведомления помощника заданий отключены.'),
('mod-quest-helper',  8, 'ruRU', 'Задание {} ("{}", флаг {}) добавлено для реалма {}.'),
('mod-quest-helper', 10, 'ruRU', 'Задание {} ("{}") [флаг {}] удалено из реалма {}.'),
('mod-quest-helper', 12, 'ruRU', 'Комментарий (ID: {}) добавлен к заданию {} ("{}") на реалме {}.'),
('mod-quest-helper', 14, 'ruRU', 'Комментарий {} удалён.'),
('mod-quest-helper', 15, 'ruRU', 'Комментарий {} скрыт.'),
('mod-quest-helper',  6, 'ruRU', 'Задание {} не найдено.'),
('mod-quest-helper',  7, 'ruRU', 'Неверный флаг. Используйте 1 (авто-выполнение) или 2 (авто-выполнение и награда).'),
('mod-quest-helper',  9, 'ruRU', 'Задание {} ("{}") не зарегистрировано для реалма {}.'),
('mod-quest-helper', 23, 'ruRU', 'Задание {} ("{}") уже зарегистрировано на реалме {} с флагом {}. Изменений не внесено.'),
('mod-quest-helper', 24, 'ruRU', 'Задание {} ("{}") на реалме {}: флаг обновлён с {} на {}.');
('mod-quest-helper', 13, 'ruRU', 'Комментарий с ID {} не найден.'),
-- koKR — strings 17-22
('mod-quest-helper', 17, 'koKR', '퀘스트 {} ("{}")은(는) 렐름 {}에 알려진 문제가 없습니다.'),
('mod-quest-helper', 18, 'koKR', '|cff4CFF00퀘스트 {} ("{}")은(는) 렐름 {}에서 자동 완료로 설정되어 있습니다.|r'),
('mod-quest-helper', 19, 'koKR', '|cff4CFF00퀘스트 {} ("{}")은(는) 렐름 {}에서 자동 완료 및 보상으로 설정되어 있습니다.|r'),
('mod-quest-helper', 20, 'koKR', '|cffFF8C00  이 설정은 임시이며 다음 서버 재시작 시 제거됩니다.|r'),
('mod-quest-helper', 21, 'koKR', '  이유: {}'),
('mod-quest-helper', 22, 'koKR', '퀘스트 {} ("{}", 플래그 {})가 렐름 {}에 추가되었습니다 (재시작 후 만료).'),
-- frFR — strings 17-22
('mod-quest-helper', 17, 'frFR', 'La quête {} ("{}") n''a aucun problème connu sur le royaume {}.'),
('mod-quest-helper', 18, 'frFR', '|cff4CFF00La quête {} ("{}") est marquée pour complétion automatique sur le royaume {}.|r'),
('mod-quest-helper', 19, 'frFR', '|cff4CFF00La quête {} ("{}") est marquée pour complétion automatique avec récompense sur le royaume {}.|r'),
('mod-quest-helper', 20, 'frFR', '|cffFF8C00  Cet indicateur est temporaire et sera supprimé au prochain redémarrage.|r'),
('mod-quest-helper', 21, 'frFR', '  Raison : {}'),
('mod-quest-helper', 22, 'frFR', 'Quête {} ("{}", indicateur {}) ajoutée pour le royaume {} (expire au prochain redémarrage).'),
-- deDE — strings 17-22
('mod-quest-helper', 17, 'deDE', 'Quest {} ("{}") hat keine bekannten Probleme auf Realm {}.'),
('mod-quest-helper', 18, 'deDE', '|cff4CFF00Quest {} ("{}") ist für Auto-Abschluss auf Realm {} markiert.|r'),
('mod-quest-helper', 19, 'deDE', '|cff4CFF00Quest {} ("{}") ist für Auto-Abschluss mit Belohnung auf Realm {} markiert.|r'),
('mod-quest-helper', 20, 'deDE', '|cffFF8C00  Dieses Flag ist temporär und wird beim nächsten Neustart entfernt.|r'),
('mod-quest-helper', 21, 'deDE', '  Grund: {}'),
('mod-quest-helper', 22, 'deDE', 'Quest {} ("{}", Flag {}) für Realm {} hinzugefügt (läuft beim nächsten Neustart ab).'),
-- zhCN — strings 17-22
('mod-quest-helper', 17, 'zhCN', '任务 {} ("{}") 在领域 {} 上没有已知问题。'),
('mod-quest-helper', 18, 'zhCN', '|cff4CFF00任务 {} ("{}") 已在领域 {} 上标记为自动完成。|r'),
('mod-quest-helper', 19, 'zhCN', '|cff4CFF00任务 {} ("{}") 已在领域 {} 上标记为自动完成并发放奖励。|r'),
('mod-quest-helper', 20, 'zhCN', '|cffFF8C00  此标记为临时性，将在下次重启时删除。|r'),
('mod-quest-helper', 21, 'zhCN', '  原因：{}'),
('mod-quest-helper', 22, 'zhCN', '任务 {} ("{}"，标志 {}) 已添加至领域 {}（下次重启后过期）。'),
-- zhTW — strings 17-22
('mod-quest-helper', 17, 'zhTW', '任務 {} ("{}") 在領域 {} 上沒有已知問題。'),
('mod-quest-helper', 18, 'zhTW', '|cff4CFF00任務 {} ("{}") 已在領域 {} 上標記為自動完成。|r'),
('mod-quest-helper', 19, 'zhTW', '|cff4CFF00任務 {} ("{}") 已在領域 {} 上標記為自動完成並發放獎勵。|r'),
('mod-quest-helper', 20, 'zhTW', '|cffFF8C00  此旗標為臨時性，將在下次重啟時刪除。|r'),
('mod-quest-helper', 21, 'zhTW', '  原因：{}'),
('mod-quest-helper', 22, 'zhTW', '任務 {} ("{}"，旗標 {}) 已新增至領域 {}（下次重啟後過期）。'),
-- esES — strings 17-22
('mod-quest-helper', 17, 'esES', 'La misión {} ("{}") no tiene problemas conocidos en el reino {}.'),
('mod-quest-helper', 18, 'esES', '|cff4CFF00La misión {} ("{}") está marcada para auto-completar en el reino {}.|r'),
('mod-quest-helper', 19, 'esES', '|cff4CFF00La misión {} ("{}") está marcada para auto-completar con recompensa en el reino {}.|r'),
('mod-quest-helper', 20, 'esES', '|cffFF8C00  Este indicador es temporal y se eliminará en el próximo reinicio.|r'),
('mod-quest-helper', 21, 'esES', '  Razón: {}'),
('mod-quest-helper', 22, 'esES', 'Misión {} ("{}", indicador {}) añadida para el reino {} (expira en el próximo reinicio).'),
-- esMX — strings 17-22
('mod-quest-helper', 17, 'esMX', 'La misión {} ("{}") no tiene problemas conocidos en el reino {}.'),
('mod-quest-helper', 18, 'esMX', '|cff4CFF00La misión {} ("{}") está marcada para auto-completar en el reino {}.|r'),
('mod-quest-helper', 19, 'esMX', '|cff4CFF00La misión {} ("{}") está marcada para auto-completar con recompensa en el reino {}.|r'),
('mod-quest-helper', 20, 'esMX', '|cffFF8C00  Este indicador es temporal y se eliminará en el próximo reinicio.|r'),
('mod-quest-helper', 21, 'esMX', '  Razón: {}'),
('mod-quest-helper', 22, 'esMX', 'Misión {} ("{}", indicador {}) agregada para el reino {} (expira en el próximo reinicio).'),
-- ruRU — strings 17-22
('mod-quest-helper', 17, 'ruRU', 'Задание {} ("{}") не имеет известных проблем на реалме {}.'),
('mod-quest-helper', 18, 'ruRU', '|cff4CFF00Задание {} ("{}") отмечено для авто-выполнения на реалме {}.|r'),
('mod-quest-helper', 19, 'ruRU', '|cff4CFF00Задание {} ("{}") отмечено для авто-выполнения с наградой на реалме {}.|r'),
('mod-quest-helper', 20, 'ruRU', '|cffFF8C00  Этот флаг временный и будет удалён при следующем перезапуске.|r'),
('mod-quest-helper', 21, 'ruRU', '  Причина: {}'),
('mod-quest-helper', 22, 'ruRU', 'Задание {} ("{}", флаг {}) добавлено для реалма {} (истекает при следующем перезапуске).');

-- ============================================================
-- Command table
-- ============================================================

DELETE FROM `command` WHERE `name` IN (
    'qh',
    'qh help',
    'qh info',
    'qh add',
    'qh addtemp',
    'qh remove',
    'qh reload',
    'qh comment',
    'qh comment add',
    'qh comment remove',
    'qh comment hide'
);

INSERT INTO `command` (`name`, `security`, `help`) VALUES
('qh',                0, 'Syntax: .qh $subcommand\n\nQuest Helper module commands. Use .qh help to toggle notifications.'),
('qh help',           0, 'Syntax: .qh help [on|off]\n\nToggles Quest Helper notifications on or off. If no argument is given the state is toggled.'),
('qh info',           1, 'Syntax: .qh info $quest [$realmId]\n\nShows the Quest Helper status for a quest: auto-complete flag, whether it is temporary, reason, and any active notes. $quest accepts a quest ID or shift-clicked quest link. realmId defaults to the current realm; use -1 for all realms.'),
('qh add',            1, 'Syntax: .qh add $quest $flag [$realmId] [$reason]\n\nRegisters a quest for auto-completion. $quest accepts a quest ID or shift-clicked quest link. Flag: 1 = complete only, 2 = complete and reward. realmId defaults to the current realm; use -1 for all realms. If the quest is already registered with a different flag, the flag is updated.'),
('qh addtemp',        1, 'Syntax: .qh addtemp $quest $flag [$realmId] [$reason]\n\nRegisters a quest for auto-completion until the next server restart. $quest accepts a quest ID or shift-clicked quest link. Flag: 1 = complete only, 2 = complete and reward. realmId defaults to the current realm; use -1 for all realms.'),
('qh remove',         1, 'Syntax: .qh remove $quest [$realmId]\n\nUnregisters a quest from auto-completion. $quest accepts a quest ID or shift-clicked quest link. realmId defaults to the current realm; use -1 for all realms.'),
('qh reload',         1, 'Syntax: .qh reload\n\nReloads all auto-complete quests and comments from the database without restarting the server.'),
('qh comment',        1, 'Syntax: .qh comment $subcommand\n\nManage GM comments displayed to players when they accept a quest.'),
('qh comment add',    1, 'Syntax: .qh comment add $quest [$realmId] $comment\n\nAttaches a comment to a quest. $quest accepts a quest ID or shift-clicked quest link. Multiple comments per quest are supported. The assigned comment ID is shown on success. realmId defaults to the current realm; use -1 for all realms.'),
('qh comment remove', 1, 'Syntax: .qh comment remove $commentId\n\nPermanently removes a comment by its ID. Use .qh comment hide to suppress it without deleting.'),
('qh comment hide',   1, 'Syntax: .qh comment hide $commentId\n\nSets a comment as hidden (enabled=0) so it is no longer shown to players, without deleting it from the database.');
