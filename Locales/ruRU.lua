-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: enUS.lua
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local _, addonTable = ...
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionProgressDataBars", "ruRU", true)
if not Locales then return end

-------------------------------------------------------------------------------
-- GENERAL
-------------------------------------------------------------------------------
Locales["ADDON_NAME"] = "Панель прогресса Ascension"
Locales["CONFIG_MODE"] = "Режим настройки"
Locales["CONFIG_MODE_DESC"] = "Показать тестовые панели для визуализации изменений в реальном времени."
Locales["FACTION_STANDINGS_RESET"] = "Сбросить настройки"
Locales["EMPTY"] = "Пусто"
Locales["AND"] = " И "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Модуль конфигурации не найден."
Locales["TOGGLE_CONFIG_WINDOW"] = "Открыть/закрыть окно настроек"

-------------------------------------------------------------------------------
-- CAROUSEL GAINS
-------------------------------------------------------------------------------
Locales["Experience"] = "Опыт"
Locales["Reputation"] = "Репутация"
Locales["House XP"] = "Опыт Дома"
Locales["Honor"] = "Честь"
Locales["Azerite"] = "Азерит"

-------------------------------------------------------------------------------
-- TABS
-------------------------------------------------------------------------------
Locales["TAB_BARS_LAYOUT"] = "Расположение панелей"
Locales["TAB_CUSTOM_GRID"] = "Свои панели"
Locales["TAB_TEXT_LAYOUT"] = "Настройка текста"
Locales["TAB_BEHAVIOR"] = "Поведение"
Locales["TAB_COLORS"] = "Цвета"
Locales["TAB_PARAGON_ALERTS"] = "Оповещения"
Locales["TAB_PROFILES"] = "Профили"

-------------------------------------------------------------------------------
-- UI CONTROLS & LABELS
-------------------------------------------------------------------------------
Locales["ENABLE"] = "Включить"
Locales["ENABLE_DESC"] = "Включить или выключить эту конкретную панель прогресса."
Locales["ANCHOR"] = "Привязка"
Locales["TOP"] = "Верх"
Locales["BOTTOM"] = "Низ"
Locales["FREE"] = "Свободно"
Locales["ORDER"] = "Порядок"
Locales["WIDTH"] = "Ширина"
Locales["HEIGHT"] = "Высота"
Locales["POS_X"] = "Позиция X"
Locales["POS_Y"] = "Позиция Y"
Locales["TXT_X"] = "Смещение текста X"
Locales["TXT_Y"] = "Смещение текста Y"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Общее смещение блоков"
Locales["GLOBAL_BAR_HEIGHT"] = "Общая высота панелей"
Locales["GLOBAL_OFFSET"] = "Общее смещение"
Locales["GLOBAL_SETTINGS"] = "Общие настройки"
Locales["PER_BLOCK_OFFSET"] = "Смещение для каждого блока"
Locales["PER_BLOCK_OFFSET_DESC"] = "Активируйте, чтобы задать независимое смещение по Y для верхнего и нижнего блоков вместо общего."
Locales["PER_BLOCK_GAP"] = "Интервал для каждого блока"
Locales["PER_BLOCK_GAP_DESC"] = "Активируйте, чтобы задать независимые интервалы для верхнего и нижнего блоков."
Locales["BAR_GAP"] = "Общий интервал между панелями"
Locales["TOP_OFFSET"] = "Смещение верхнего блока"
Locales["BOTTOM_OFFSET"] = "Смещение нижнего блока"
Locales["BLOCK_HEIGHT"] = "Высота блока панели"
Locales["USE_PER_BLOCK_HEIGHT"] = "Своя высота для каждого блока"
Locales["USE_PER_BLOCK_HEIGHT_DESC"] = "Активируйте, чтобы задать разную высоту панелей для верхнего и нижнего блоков."
Locales["USE_CUSTOM_HEIGHT"] = "Использовать свою высоту"
Locales["USE_CUSTOM_HEIGHT_DESC"] = "Переключение между использованием общей высоты блока и установкой уникальной высоты для этой панели."
Locales["CUSTOM_HEIGHT"] = "Пользовательская высота"
Locales["USE_PER_GROUP_SIZE"] = "Свой размер для каждой группы"
Locales["USE_PER_GROUP_COLOR"] = "Свой цвет для каждой группы"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Использовать свой размер текста"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Использовать свой цвет текста"
Locales["GROUP_SIZE"] = "Размер текста группы"
Locales["GROUP_COLOR"] = "Цвет текста группы"
Locales["CUSTOM_TEXT_SIZE"] = "Пользовательский размер текста"
Locales["CUSTOM_TEXT_COLOR"] = "Пользовательский цвет текста"
Locales["TOP_GAP"] = "Интервал верхнего блока"
Locales["BOTTOM_GAP"] = "Интервал нижнего блока"
Locales["BAR_MANAGEMENT"] = "Управление панелями"
Locales["TOP_BLOCK"] = "Верхний блок"
Locales["BOTTOM_BLOCK"] = "Нижний блок"
Locales["FREE_MODE"] = "Свободный режим"
Locales["DIM_ALPHA"] = "Прозрачность при затенении"
Locales["CAROUSEL_OPTIONS"] = "Настройки карусели"
Locales["CAROUSEL_X_OFFSET"] = "Смещение по X"
Locales["CAROUSEL_Y_OFFSET"] = "Смещение по Y"
Locales["CAROUSEL_BG_ALPHA"] = "Прозрачность фона"

-------------------------------------------------------------------------------
-- EXPERIENCE BAR
-------------------------------------------------------------------------------
Locales["EXPERIENCE"] = "Опыт"
Locales["XP_BAR_DATA"] = "Данные полосы опыта | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Опыт: 75% (Отдых)"
Locales["RESTED_XP"] = "Бонус отдыха"
Locales["RESTED_TEXT"] = "Отдых"
Locales["LEVEL_TEXT"] = "Уровень %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Уровень %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Уровень %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Уровень %d | %.1f%%"
Locales["RESTED_LABEL"] = "Бонус отдыха: %s"

-------------------------------------------------------------------------------
-- REPUTATION BAR
-------------------------------------------------------------------------------
Locales["REPUTATION"] = "Репутация"
Locales["REP_BAR_DATA"] = "Данные полосы репутации | 0/0 (0.0%)"
Locales["PARAGON"] = "Идеал"
Locales["RENOWN_LEVEL"] = "Уровень известности"
Locales["REWARD_PENDING_STATUS"] = "Награда ожидает"
Locales["REWARD_PENDING_SINGLE"] = " ЕСТЬ НАГРАДА!"
Locales["REWARD_PENDING_PLURAL"] = " ЕСТЬ НАГРАДЫ!"
Locales["ADD_CUSTOM_REPUTATION"] = "Добавить свою репутацию"
Locales["SEARCH_FACTION"] = "Поиск фракции"
Locales["SELECT_FACTION"] = "Выбрать фракцию"
Locales["ADD"] = "Добавить"
Locales["DELETE"] = "Удалить"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-------------------------------------------------------------------------------
-- HONOR BAR
-------------------------------------------------------------------------------
Locales["HONOR"] = "Честь"
Locales["HONOR_LEVEL_SIMPLE"] = "Уровень чести %d"
Locales["ENABLE_HONOR_BAR"] = "Включить панель чести"
Locales["HONOR_BAR_DATA"] = "Честь: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Высота панели чести"
Locales["HONOR_LEVEL_FORMAT"] = "Уровень чести %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- AZERITE BAR
-------------------------------------------------------------------------------
Locales["AZERITE"] = "Азерит"
Locales["ENABLE_AZERITE_BAR"] = "Включить панель азерита"
Locales["AZERITE_BAR_DATA"] = "Сила азерита: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Высота панели азерита"
Locales["AZERITE_LEVEL_FORMAT"] = "Уровень азерита %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- HOUSING FAVOR BAR
-------------------------------------------------------------------------------
Locales["HOUSE_FAVOR"] = "Уровень опыта дома"
Locales["ENABLE_HOUSE_XP_BAR"] = "Включить панель опыта дома"
Locales["HOUSE_XP"] = "Опыт дома"
Locales["HOUSE_BAR_HEIGHT"] = "Высота панели дома"
Locales["HOUSE_LEVEL_FORMAT"] = "%s: Уровень %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s: Уровень %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s: Уровень %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s: Уровень %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "ДОСТУПНЫ УЛУЧШЕНИЯ ДОМА ДЛЯ %s"

-------------------------------------------------------------------------------
-- TEXT LAYOUT TAB
-------------------------------------------------------------------------------
Locales["TEXT_AND_FONT"] = "Текст и шрифт"
Locales["LAYOUT_MODE"] = "Режим макета"
Locales["ALL_IN_ONE_LINE"] = "Все в одну строку"
Locales["MULTIPLE_LINES"] = "В несколько строк"
Locales["TEXT_FOLLOWS_BAR"] = "Текст следует за панелью"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Текстовая группа 1 будет следовать за позицией нижней активной панели."
Locales["FONT_SIZE"] = "Размер шрифта"
Locales["GLOBAL_TEXT_COLOR"] = "Общий цвет текста"
Locales["TEXT_GROUP_POSITIONS"] = "Позиции групп текста"
Locales["DETACH_GROUP"] = "Отсоединить группу %d"
Locales["DETACH_GROUP_DESC"] = "Разрешить группе %d позиционироваться независимо."
Locales["GROUP_X"] = "Смещение группы %d по X"
Locales["GROUP_Y"] = "Смещение группы %d по Y"
Locales["TEXT_MANAGEMENT"] = "Управление текстом"
Locales["TEXT_SIZE"] = "Размер текста"
Locales["GROUP_1"] = "Группа 1"
Locales["GROUP_2"] = "Группа 2"
Locales["GROUP_3"] = "Группа 3"

-------------------------------------------------------------------------------
-- BEHAVIOR TAB
-------------------------------------------------------------------------------
Locales["AUTO_HIDE_LOGIC"] = "Логика авто-скрытия"
Locales["BARS_HIDDEN_COMBAT_HOVER"] = "Панели скрыты — наведите мышь для показа (скрыто в бою)"
Locales["BARS_HIDDEN_HOVER"] = "Панели скрыты — наведите мышь для показа"
Locales["BARS_HIDDEN_COMBAT"] = "Панели скрыты в бою"
Locales["SHOW_ON_MOUSEOVER"] = "Показывать при наведении"
Locales["SHOW_ON_MOUSEOVER_DESC"] = "Показывать панели только при наведении мыши. Если отключено, панели всегда видны (если не активно скрытие в бою)."
Locales["HIDE_IN_COMBAT"] = "Скрывать в бою"
Locales["HIDE_IN_COMBAT_DESC"] = "Автоматически скрывать панели при входе в бой для уменьшения загроможденности интерфейса."
Locales["HIDE_AT_MAX_LEVEL"] = "Скрывать опыт на макс. уровне"
Locales["HIDE_AT_MAX_LEVEL_DESC"] = "Автоматически скрывать полосу опыта, когда персонаж достигает максимального уровня."
Locales["DATA_DISPLAY"] = "Отображение данных"
Locales["SHOW_PERCENTAGE"] = "Показывать проценты"
Locales["SHOW_PERCENTAGE_DESC"] = "Отображать процент прогресса на панелях."
Locales["SHOW_ABSOLUTE_VALUES"] = "Показывать абсолютные значения"
Locales["SHOW_ABSOLUTE_VALUES_DESC"] = "Отображать текущее и максимальное значения целиком (например, 1200 / 5000)."
Locales["SHOW_SPARK"] = "Показывать искру"
Locales["SHOW_SPARK_DESC"] = "Отображать яркую искру на переднем крае полосы прогресса для лучшей видимости."

-------------------------------------------------------------------------------
-- COLORS TAB
-------------------------------------------------------------------------------
Locales["USE_CLASS_COLOR"] = "Цвет класса"
Locales["USE_CLASS_COLOR_DESC"] = "Окрашивать полосу опыта в цвет вашего класса."
Locales["CUSTOM_XP_COLOR"] = "Свой цвет опыта"
Locales["SHOW_RESTED_BAR"] = "Показывать полосу отдыха"
Locales["SHOW_RESTED_BAR_DESC"] = "Отображать дополнительную полосу накопленного бонуса отдыха."
Locales["RESTED_COLOR"] = "Цвет отдыха"
Locales["USE_REACTION_COLORS"] = "Цвета отношений (реакции)"
Locales["USE_REACTION_COLORS_DESC"] = "Автоматически окрашивать полосу репутации в зависимости от ваших отношений с фракцией (Ненависть, Нейтралитет, Превознесение и т.д.)."
Locales["CUSTOM_REP_COLOR"] = "Свой цвет репутации"
Locales["HONOR_COLOR"] = "Цвет чести"
Locales["HOUSE_XP_COLOR"] = "Цвет опыта дома"
Locales["HOUSE_REWARD_COLOR"] = "Цвет текста награды дома"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Смещение награды дома по Y"
Locales["AZERITE_COLOR"] = "Цвет азерита"

-------------------------------------------------------------------------------
-- REPUTATION STANDINGS
-------------------------------------------------------------------------------
Locales["HATED"] = "Ненависть"
Locales["HOSTILE"] = "Враждебность"
Locales["UNFRIENDLY"] = "Неприязнь"
Locales["NEUTRAL"] = "Равнодушие"
Locales["FRIENDLY"] = "Дружелюбие"
Locales["HONORED"] = "Уважение"
Locales["REVERED"] = "Почтение"
Locales["EXALTED"] = "Превознесение"
Locales["MAXED"] = "Максимум"
Locales["RENOWN"] = "Известность"
Locales["RANK_NUM"] = "Ранг %d"

-------------------------------------------------------------------------------
-- PARAGON ALERTS
-------------------------------------------------------------------------------
Locales["ALERT_STYLING"] = "Стиль оповещений"
Locales["SPLIT_LINES"] = "Разделять на строки"
Locales["SPLIT_LINES_DESC"] = "Если ожидают несколько наград Идеала, показывать каждую фракцию в отдельной строке вместо объединения."
Locales["ALERT_COLOR"] = "Цвет оповещения"
Locales["REWARD_AVAILABLE"] = "ДОСТУПНА НАГРАДА"
Locales["REWARD_ON_CHAR"] = "НАГРАДА ДОСТУПНА НА %s"
Locales["PARAGON_TEXT_SIZE"] = "Размер текста оповещения"

-------------------------------------------------------------------------------
-- CUSTOM GRID MODE
-------------------------------------------------------------------------------
Locales["CUSTOM_GRID"] = "Свои панели"
Locales["CUSTOM_GRID_ENABLE"] = "Включить свою сетку макета"
Locales["CUSTOM_GRID_ENABLE"] = "Включить свою сетку макета"
Locales["ENABLE_ADVANCED_GRID"] = "Включить настраиваемую сетку (расширенно)"
Locales["ENABLE_ADVANCED_GRID_DESC"] = "Включите расширенную систему сетки, чтобы вручную размещать панели в строках и столбцах. Это переопределяет стандартную логику макета."
Locales["GRID_OPTIONS"] = "Конфигурация сетки"
Locales["GRID_ROWS"] = "Всего строк"
Locales["GRID_COLS_FOR_ROW"] = "Колонок в строке %d"
Locales["GRID_CELL"] = "Строка %d - Колонка %d"
Locales["GRID_PRESET"] = "Шаблон макета"
Locales["PRESET_CUSTOM"] = "Свой"
Locales["PRESET_2X1"] = "2x1 (2 строки, 1 колонка)"
Locales["PRESET_2X2"] = "2x2 (2 строки, 2 колонки)"
Locales["PRESET_3X2"] = "3x2 (3 строки, 2 колонки)"
Locales["ASSIGN_BAR"] = "Назначить панель"

-------------------------------------------------------------------------------
-- TEXT LAYOUT (additional)
-------------------------------------------------------------------------------
Locales["BLOCK_TEXT_MODE"] = "Поведение текста"
Locales["TEXT_VISIBILITY_MODE"] = "Режим видимости текста"
Locales["FOCUS_MODE"] = "Показывать при наведении"
Locales["GRID_DYNAMIC"] = "Всегда видно"
Locales["NONE"] = "Нет"
Locales["BASE_TYPOGRAPHY"] = "Базовая типографика"
Locales["FONT_OUTLINE"] = "Контур шрифта"
Locales["VISUAL_OPTIONS"] = "Визуальные настройки"
Locales["SHOW_RESTED"] = "Показывать бонус отдыха"
Locales["USE_COMPACT_FORMAT"] = "Компактный формат"
Locales["USE_COMPACT_FORMAT_DESC"] = "Форматировать большие числа в более короткий и читаемый вид (например, 1.2k вместо 1200)."
Locales["EVENTS_VISIBILITY"] = "Видимость"
Locales["ENABLE_CAROUSEL"] = "Включить карусель событий"
Locales["ENABLE_CAROUSEL_DESC"] = "Отображать сменяющийся баннер с последними получениями опыта и репутации."
Locales["LATERAL_LEGEND"] = "Включить боковую легенду"
Locales["LATERAL_LEGEND_DESC"] = "Отображать постоянную легенду с текущим состоянием всех активных панелей."
Locales["DYNAMIC_GRID_GAP"] = "Интервал сетки"
Locales["LEGEND_OPTIONS"] = "Настройки легенды"
Locales["LEGEND_TEXT_SIZE"] = "Размер текста легенды"
Locales["LEGEND_BG_ALPHA"] = "Прозрачность фона легенды"
Locales["LEGEND_FONT_OUTLINE"] = "Контур шрифта легенды"

-------------------------------------------------------------------------------
-- CONFIG / PREVIEW STRINGS
-------------------------------------------------------------------------------
Locales["CONFIG_FACTION_A_REWARD"] = "[НАСТРОЙКА] НАГРАДА ФРАКЦИИ А"
Locales["CONFIG_FACTION_B_REWARD"] = "[НАСТРОЙКА] НАГРАДА ФРАКЦИИ Б"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[НАСТРОЙКА] ОЖИДАЮТ НЕСКОЛЬКО НАГРАД!"

-------------------------------------------------------------------------------
-- PROFILES TAB
-------------------------------------------------------------------------------
Locales["PROFILES"] = "Профили"
Locales["PROFILE_DESC_1"] = "Вы можете сменить активный профиль базы данных, чтобы использовать разные настройки для каждого персонажа."
Locales["PROFILE_DESC_2"] = "Сбросить текущий профиль до значений по умолчанию."
Locales["RESET_PROFILE"] = "Сбросить профиль"
Locales["CURRENT_PROFILE"] = "Текущий профиль:"
Locales["PROFILE_DESC_3"] = "Создать новый профиль или выбрать существующий."
Locales["NEW"] = "Новый профиль"
Locales["EXISTING_PROFILES"] = "Существующие профили"
Locales["COPY_PROFILE_DESC"] = "Копировать настройки из другого профиля в текущий."
Locales["COPY_FROM"] = "Копировать из"
Locales["DELETE_PROFILE_DESC"] = "Удалите неиспользуемые профили, чтобы сэкономить место."
Locales["DELETE_PROFILE"] = "Удалить профиль"
Locales["DELETE_PROFILE_CONFIRM"] = "Удалить профиль '%s'?"
Locales["ACCEPT"] = "Принять"
Locales["CANCEL"] = "Отмена"
Locales["YES"] = "Да"
Locales["NO"] = "Нет"
Locales["IMPORT_PROFILE"] = "Импорт профиля"
Locales["EXPORT_PROFILE"] = "Экспорт профиля"
Locales["IMPORT_EXPORT_DESC"] = "Поделитесь своей конфигурацией с другими игроками."
Locales["CLOSE"] = "Закрыть"
Locales["IMPORT"] = "Импорт"
Locales["RESET_CONFIRM"] = "Вы уверены, что хотите сбросить профиль '%s' к настройкам по умолчанию?"
