/* eslint-disable no-unused-vars */
const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const { Adw, Gdk, Gio, GLib, GObject, Gtk } = imports.gi;
const Gettext = imports.gettext.domain(Me.metadata['gettext-domain']);
const _ = Gettext.gettext;

const PAYPAL_LINK = `https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=53CWA7NR743WC&item_name=Support+${Me.metadata.name}&source=url`;
const PROJECT_DESCRIPTION = _('Show running apps and favorites on the main panel');
const PROJECT_IMAGE = 'aztaskbar-logo';
const SCHEMA_PATH = '/org/gnome/shell/extensions/aztaskbar/';

var GeneralPage = GObject.registerClass(
class azTaskbarGeneralPage extends Adw.PreferencesPage {
    _init(settings) {
        super._init({
            title: _('Settings'),
            icon_name: 'preferences-system-symbolic',
            name: 'GeneralPage',
        });

        this._settings = settings;

        const generalGroup = new Adw.PreferencesGroup({
            title: _('Taskbar Behavior'),
        });
        this.add(generalGroup);

        const panelPositions = new Gtk.StringList();
        panelPositions.append(_('Left'));
        panelPositions.append(_('Center'));
        panelPositions.append(_('Right'));
        const panelPositionRow = new Adw.ComboRow({
            title: _('Position in Panel'),
            model: panelPositions,
            selected: this._settings.get_enum('position-in-panel'),
        });
        panelPositionRow.connect('notify::selected', widget => {
            this._settings.set_enum('position-in-panel', widget.selected);
        });
        generalGroup.add(panelPositionRow);

        const positionOffsetSpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 0, upper: 15, step_increment: 1, page_increment: 1, page_size: 0,
            }),
            climb_rate: 1,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
        });
        positionOffsetSpinButton.set_value(this._settings.get_int('position-offset'));
        positionOffsetSpinButton.connect('value-changed', widget => {
            this._settings.set_int('position-offset', widget.get_value());
        });
        const positionOffsetRow = new Adw.ActionRow({
            title: _('Position Offset'),
            subtitle: _('Offset the position within the above selected box'),
            activatable_widget: positionOffsetSpinButton,
        });
        positionOffsetRow.add_suffix(positionOffsetSpinButton);
        generalGroup.add(positionOffsetRow);

        const [showAppsButton, showAppsButtonPosition] =
            this._settings.get_value('show-apps-button').deep_unpack();

        const showAppsButtonSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        showAppsButtonSwitch.connect('notify::active', widget => {
            const [oldEnabled_, oldValue] = this._settings.get_value('show-apps-button').deep_unpack();
            this._settings.set_value('show-apps-button',
                new GLib.Variant('(bi)', [widget.get_active(), oldValue]));
            if (widget.get_active())
                showAppsButtonCombo.set_sensitive(true);
            else
                showAppsButtonCombo.set_sensitive(false);
        });
        const showAppsButtonCombo = new Gtk.ComboBoxText({
            valign: Gtk.Align.CENTER,
            sensitive: showAppsButton,
        });
        showAppsButtonCombo.append_text(_('Left'));
        showAppsButtonCombo.append_text(_('Right'));
        showAppsButtonCombo.set_active(showAppsButtonPosition);
        showAppsButtonCombo.connect('changed', widget => {
            const [oldEnabled, oldValue_] = this._settings.get_value('show-apps-button').deep_unpack();
            this._settings.set_value('show-apps-button',
                new GLib.Variant('(bi)', [oldEnabled, widget.get_active()]));
        });

        const showAppsButtonRow = new Adw.ActionRow({
            title: _('Show Apps Button'),
            activatable_widget: showAppsButtonSwitch,
        });
        showAppsButtonRow.use_markup = true;
        showAppsButtonRow.add_suffix(showAppsButtonSwitch);
        showAppsButtonRow.add_suffix(new Gtk.Separator({
            orientation: Gtk.Orientation.VERTICAL,
            margin_top: 10,
            margin_bottom: 10,
        }));
        showAppsButtonRow.add_suffix(showAppsButtonCombo);
        showAppsButtonSwitch.set_active(showAppsButton);
        generalGroup.add(showAppsButtonRow);

        const favoritesSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const favoritesRow = new Adw.ActionRow({
            title: _('Show Favorites'),
            activatable_widget: favoritesSwitch,
        });
        favoritesSwitch.set_active(this._settings.get_boolean('favorites'));
        favoritesSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('favorites', widget.get_active());
        });
        favoritesRow.add_suffix(favoritesSwitch);
        generalGroup.add(favoritesRow);

        const runningAppsRow = new Adw.ExpanderRow({
            title: _('Show Running Apps'),
            show_enable_switch: true,
            expanded: false,
            enable_expansion: this._settings.get_boolean('show-running-apps'),
        });
        runningAppsRow.connect('notify::enable-expansion', widget => {
            this._settings.set_boolean('show-running-apps', widget.enable_expansion);
        });
        generalGroup.add(runningAppsRow);

        const isolateWorkspacesSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const isolateWorkspacesRow = new Adw.ActionRow({
            title: _('Isolate Workspaces'),
            activatable_widget: isolateWorkspacesSwitch,
        });
        isolateWorkspacesSwitch.set_active(this._settings.get_boolean('isolate-workspaces'));
        isolateWorkspacesSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('isolate-workspaces', widget.get_active());
        });
        isolateWorkspacesRow.add_suffix(isolateWorkspacesSwitch);
        runningAppsRow.add_row(isolateWorkspacesRow);

        const isolateMonitorsSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const isolateMonitorsRow = new Adw.ActionRow({
            title: _('Isolate Monitors'),
            activatable_widget: isolateMonitorsSwitch,
        });
        isolateMonitorsSwitch.set_active(this._settings.get_boolean('isolate-monitors'));
        isolateMonitorsSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('isolate-monitors', widget.get_active());
        });
        isolateMonitorsRow.add_suffix(isolateMonitorsSwitch);
        runningAppsRow.add_row(isolateMonitorsRow);

        const panelGroup = new Adw.PreferencesGroup({
            title: _('Panel'),
        });
        this.add(panelGroup);

        const panelLocations = new Gtk.StringList();
        panelLocations.append(_('Top'));
        panelLocations.append(_('Bottom'));
        const panelLocationRow = new Adw.ComboRow({
            title: _('Panel Location'),
            model: panelLocations,
            selected: this._settings.get_enum('panel-location'),
        });
        panelLocationRow.connect('notify::selected', widget => {
            this._settings.set_enum('panel-location', widget.selected);
        });
        panelGroup.add(panelLocationRow);

        const showOnAllMonitorsSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const showOnAllMonitorsRow = new Adw.ActionRow({
            title: _('Show Panels on All Monitors'),
            activatable_widget: showOnAllMonitorsSwitch,
        });
        showOnAllMonitorsSwitch.set_active(this._settings.get_boolean('panel-on-all-monitors'));
        showOnAllMonitorsSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('panel-on-all-monitors', widget.get_active());
        });
        showOnAllMonitorsRow.add_suffix(showOnAllMonitorsSwitch);
        panelGroup.add(showOnAllMonitorsRow);

        const [panelHeightOverride, panelHeight] =
            this._settings.get_value('main-panel-height').deep_unpack();

        const panelHeightSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        panelHeightSwitch.connect('notify::active', widget => {
            const [oldEnabled_, oldValue] = this._settings.get_value('main-panel-height').deep_unpack();
            this._settings.set_value('main-panel-height',
                new GLib.Variant('(bi)', [widget.get_active(), oldValue]));
            if (widget.get_active())
                panelHeightSpinButton.set_sensitive(true);
            else
                panelHeightSpinButton.set_sensitive(false);
        });
        const panelHeightSpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 5,
                upper: 60,
                step_increment: 1,
            }),
            climb_rate: 1,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
            value: panelHeight,
            sensitive: panelHeightOverride,
        });
        panelHeightSpinButton.connect('value-changed', widget => {
            const [oldEnabled, oldValue_] = this._settings.get_value('main-panel-height').deep_unpack();
            this._settings.set_value('main-panel-height',
                new GLib.Variant('(bi)', [oldEnabled, widget.get_value()]));
        });

        const panelHeightRow = new Adw.ActionRow({
            title: _('Panel Height'),
            activatable_widget: panelHeightSwitch,
        });
        panelHeightRow.add_suffix(panelHeightSwitch);
        panelHeightRow.add_suffix(new Gtk.Separator({
            orientation: Gtk.Orientation.VERTICAL,
            margin_top: 10,
            margin_bottom: 10,
        }));
        panelHeightRow.add_suffix(panelHeightSpinButton);
        panelHeightSwitch.set_active(panelHeightOverride);
        panelGroup.add(panelHeightRow);

        const activitiesSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const activitiesRow = new Adw.ActionRow({
            title: _('Show Activities Button'),
            activatable_widget: activitiesSwitch,
        });
        activitiesSwitch.set_active(this._settings.get_boolean('show-panel-activities-button'));
        activitiesSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('show-panel-activities-button', widget.get_active());
        });
        activitiesRow.add_suffix(activitiesSwitch);
        panelGroup.add(activitiesRow);

        const appMenuSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const appMenuRow = new Adw.ActionRow({
            title: _('Show App Menu Button'),
            subtitle: _('Panel menu button that shows focused app'),
            activatable_widget: appMenuSwitch,
        });
        appMenuSwitch.set_active(this._settings.get_boolean('show-panel-appmenu-button'));
        appMenuSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('show-panel-appmenu-button', widget.get_active());
        });
        appMenuRow.add_suffix(appMenuSwitch);
        panelGroup.add(appMenuRow);

        const iconGroup = new Adw.PreferencesGroup({
            title: _('App Icons'),
        });
        this.add(iconGroup);

        const iconSizeSpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 15, upper: 50, step_increment: 1, page_increment: 1, page_size: 0,
            }),
            climb_rate: 1,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
        });
        iconSizeSpinButton.set_value(this._settings.get_int('icon-size'));
        iconSizeSpinButton.connect('value-changed', widget => {
            this._settings.set_int('icon-size', widget.get_value());
        });
        const iconSizeRow = new Adw.ActionRow({
            title: _('Icon Size'),
            activatable_widget: iconSizeSpinButton,
        });
        iconSizeRow.add_suffix(iconSizeSpinButton);
        iconGroup.add(iconSizeRow);

        const desatureFactorSpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 0.0, upper: 1.0, step_increment: 0.05, page_increment: 0.1, page_size: 0,
            }),
            climb_rate: 0.05,
            digits: 2,
            numeric: true,
            valign: Gtk.Align.CENTER,
        });
        desatureFactorSpinButton.set_value(this._settings.get_double('desaturation-factor'));
        desatureFactorSpinButton.connect('value-changed', widget => {
            this._settings.set_double('desaturation-factor', widget.get_value());
        });
        const desatureFactorRow = new Adw.ActionRow({
            title: _('Icon Desaturate Factor'),
            activatable_widget: desatureFactorSpinButton,
        });
        desatureFactorRow.add_suffix(desatureFactorSpinButton);
        iconGroup.add(desatureFactorRow);

        const iconStyles = new Gtk.StringList();
        iconStyles.append(_('Regular'));
        iconStyles.append(_('Symbolic'));
        const iconStyleRow = new Adw.ComboRow({
            title: _('Icon Style'),
            subtitle: _('Icon themes may not have a symbolic icon for every app'),
            model: iconStyles,
            selected: this._settings.get_enum('icon-style'),
        });
        iconStyleRow.connect('notify::selected', widget => {
            this._settings.set_enum('icon-style', widget.selected);
        });
        iconGroup.add(iconStyleRow);

        const danceUrgentSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
            active: this._settings.get_boolean('dance-urgent'),
        });
        const danceUrgentRow = new Adw.ActionRow({
            title: _('Dance Urgent App Icons'),
            activatable_widget: danceUrgentSwitch,
        });
        danceUrgentSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('dance-urgent', widget.get_active());
        });
        danceUrgentRow.add_suffix(danceUrgentSwitch);
        iconGroup.add(danceUrgentRow);

        const indicatorGroup = new Adw.PreferencesGroup({
            title: _('Indicator'),
        });
        this.add(indicatorGroup);

        const multiWindowIndicatorStyles = new Gtk.StringList();
        multiWindowIndicatorStyles.append(_('Indicator'));
        multiWindowIndicatorStyles.append(_('Multi-Dashes'));
        const multiWindowIndicatorRow = new Adw.ComboRow({
            title: _('Multi-Window Indicator Style'),
            model: multiWindowIndicatorStyles,
            selected: this._settings.get_enum('multi-window-indicator-style'),
        });
        multiWindowIndicatorRow.connect('notify::selected', widget => {
            this._settings.set_enum('multi-window-indicator-style', widget.selected);
        });
        indicatorGroup.add(multiWindowIndicatorRow);

        const indicatorLocations = new Gtk.StringList();
        indicatorLocations.append(_('Top'));
        indicatorLocations.append(_('Bottom'));
        const indicatorLocationRow = new Adw.ComboRow({
            title: _('Indicator Location'),
            model: indicatorLocations,
            selected: this._settings.get_enum('indicator-location'),
        });
        indicatorLocationRow.connect('notify::selected', widget => {
            this._settings.set_enum('indicator-location', widget.selected);
        });
        indicatorGroup.add(indicatorLocationRow);

        let color = new Gdk.RGBA();
        color.parse(this._settings.get_string('indicator-color-running'));
        const indicatorRunningColorButton = new Gtk.ColorButton({
            rgba: color,
            use_alpha: true,
            valign: Gtk.Align.CENTER,
        });
        indicatorRunningColorButton.connect('color-set', widget => {
            const widgetColor = widget.get_rgba().to_string();
            this._settings.set_string('indicator-color-running', widgetColor);
        });
        const indicatorRunningRow = new Adw.ActionRow({
            title: _('Running Indicator Color'),
            activatable_widget: indicatorRunningColorButton,
        });
        indicatorRunningRow.add_suffix(indicatorRunningColorButton);
        indicatorGroup.add(indicatorRunningRow);

        color = new Gdk.RGBA();
        color.parse(this._settings.get_string('indicator-color-focused'));
        const indicatorFocusedColorButton = new Gtk.ColorButton({
            rgba: color,
            use_alpha: true,
            valign: Gtk.Align.CENTER,
        });
        indicatorFocusedColorButton.connect('color-set', widget => {
            const widgetColor = widget.get_rgba().to_string();
            this._settings.set_string('indicator-color-focused', widgetColor);
        });

        const indicatorFocusedRow = new Adw.ActionRow({
            title: _('Focused Indicator Color'),
            activatable_widget: indicatorFocusedColorButton,
        });
        indicatorFocusedRow.add_suffix(indicatorFocusedColorButton);
        indicatorGroup.add(indicatorFocusedRow);

        const badgesGroup = new Adw.PreferencesGroup({
            title: _('Taskbar Badges'),
        });
        this.add(badgesGroup);

        const notificationCounterSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
            active: this._settings.get_boolean('notification-badges'),
        });
        const notificationCounterRow = new Adw.ActionRow({
            title: _('Notification Badges Count'),
            // eslint-disable-next-line max-len
            subtitle: _('Adds a badge counter to the App Icon based on GNOME shell notifications'),
            activatable_widget: notificationCounterSwitch,
        });
        notificationCounterSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('notification-badges', widget.get_active());
        });
        notificationCounterRow.add_suffix(notificationCounterSwitch);
        badgesGroup.add(notificationCounterRow);

        const unityCountSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
            active: this._settings.get_boolean('unity-badges'),
        });
        const unityCountRow = new Adw.ActionRow({
            title: _('Unity Badges Count'),
            subtitle: _('Requires Unity API'),
            activatable_widget: unityCountSwitch,
        });
        unityCountSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('unity-badges', widget.get_active());
        });
        unityCountRow.add_suffix(unityCountSwitch);
        badgesGroup.add(unityCountRow);

        const progressSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
            active: this._settings.get_boolean('unity-progress-bars'),
        });
        const progressRow = new Adw.ActionRow({
            title: _('Unity Progress Bars'),
            subtitle: _('Requires Unity API'),
            activatable_widget: progressSwitch,
        });
        progressSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('unity-progress-bars', widget.get_active());
        });
        progressRow.add_suffix(progressSwitch);
        badgesGroup.add(progressRow);
    }
});

var ActionsPage = GObject.registerClass(
class azTaskbarActionsPage extends Adw.PreferencesPage {
    _init(settings) {
        super._init({
            title: _('Actions'),
            icon_name: 'input-mouse-symbolic',
            name: 'ActionsPage',
        });
        this._settings = settings;

        const clickActionGroup = new Adw.PreferencesGroup({
            title: _('Click Actions'),
        });
        this.add(clickActionGroup);

        const clickOptions = new Gtk.StringList();
        clickOptions.append(_('Toggle / Cycle'));
        clickOptions.append(_('Toggle / Cycle + Minimize'));
        clickOptions.append(_('Toggle / Preview'));
        clickOptions.append(_('Cycle'));
        const clickOptionsMenu = new Gtk.DropDown({
            valign: Gtk.Align.CENTER,
            model: clickOptions,
            selected: this._settings.get_enum('click-action'),
        });
        const clickOptionsRow = new Adw.ActionRow({
            title: _('Left Click'),
            activatable_widget: clickOptionsMenu,
        });
        clickOptionsRow.add_suffix(clickOptionsMenu);
        clickOptionsMenu.connect('notify::selected', widget => {
            this._settings.set_enum('click-action', widget.selected);
        });
        clickActionGroup.add(clickOptionsRow);

        const middleClickOptions = new Gtk.StringList();
        middleClickOptions.append(_('Toggle / Cycle'));
        middleClickOptions.append(_('Toggle / Cycle + Minimize'));
        middleClickOptions.append(_('Toggle / Preview'));
        middleClickOptions.append(_('Cycle'));
        middleClickOptions.append(_('Raise'));
        middleClickOptions.append(_('Minimize'));
        middleClickOptions.append(_('Quit'));
        middleClickOptions.append(_('Launch New Instance'));
        const middleClickOptionsMenu = new Gtk.DropDown({
            valign: Gtk.Align.CENTER,
            model: middleClickOptions,
            selected: this._settings.get_enum('middle-click-action'),
        });
        const middleClickOptionsRow = new Adw.ActionRow({
            title: _('Middle Click'),
            activatable_widget: middleClickOptionsMenu,
        });
        middleClickOptionsRow.add_suffix(middleClickOptionsMenu);
        middleClickOptionsMenu.connect('notify::selected', widget => {
            this._settings.set_enum('middle-click-action', widget.selected);
        });
        clickActionGroup.add(middleClickOptionsRow);

        const shiftMiddleClickOptionsMenu = new Gtk.DropDown({
            valign: Gtk.Align.CENTER,
            model: middleClickOptions,
            selected: this._settings.get_enum('shift-middle-click-action'),
        });
        const shiftMiddleClickOptionsRow = new Adw.ActionRow({
            title: _('Shift + Middle Click'),
            activatable_widget: middleClickOptionsMenu,
        });
        shiftMiddleClickOptionsRow.add_suffix(shiftMiddleClickOptionsMenu);
        shiftMiddleClickOptionsMenu.connect('notify::selected', widget => {
            this._settings.set_enum('shift-middle-click-action', widget.selected);
        });
        clickActionGroup.add(shiftMiddleClickOptionsRow);

        const scrollActionGroup = new Adw.PreferencesGroup({
            title: _('Scroll Actions'),
        });
        this.add(scrollActionGroup);

        const scrollOptions = new Gtk.StringList();
        scrollOptions.append(_('Cycle Windows'));
        scrollOptions.append(_('No Action'));
        const scrollOptionsRow = new Adw.ComboRow({
            title: _('Scroll Action'),
            model: scrollOptions,
            selected: this._settings.get_enum('scroll-action'),
        });
        scrollOptionsRow.connect('notify::selected', widget => {
            this._settings.set_enum('scroll-action', widget.selected);
        });
        scrollActionGroup.add(scrollOptionsRow);

        const hoverActionGroup = new Adw.PreferencesGroup({
            title: _('Hover Actions'),
        });
        this.add(hoverActionGroup);

        const toolTipsSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const toolTipsRow = new Adw.ActionRow({
            title: _('Tool-Tips'),
            activatable_widget: toolTipsSwitch,
        });
        toolTipsSwitch.set_active(this._settings.get_boolean('tool-tips'));
        toolTipsSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('tool-tips', widget.get_active());
        });
        toolTipsRow.add_suffix(toolTipsSwitch);
        hoverActionGroup.add(toolTipsRow);

        const windowPreviewsSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const windowPreviewsOptionsButton = new Gtk.Button({
            child: new Adw.ButtonContent({ icon_name: 'emblem-system-symbolic' }),
            valign: Gtk.Align.CENTER,
        });
        windowPreviewsOptionsButton.connect('clicked', () => {
            const windowPreviewOptions = new WindowPreviewOptions(this.get_root(), this._settings);
            windowPreviewOptions.show();
        });
        const windowPreviewsRow = new Adw.ActionRow({
            title: _('Window Previews'),
            activatable_widget: windowPreviewsSwitch,
        });
        windowPreviewsSwitch.set_active(this._settings.get_boolean('window-previews'));
        windowPreviewsOptionsButton.set_sensitive(this._settings.get_boolean('window-previews'));
        windowPreviewsSwitch.connect('notify::active', widget => {
            windowPreviewsOptionsButton.set_sensitive(widget.get_active());
            this._settings.set_boolean('window-previews', widget.get_active());
        });
        windowPreviewsRow.add_suffix(windowPreviewsOptionsButton);
        windowPreviewsRow.add_suffix(windowPreviewsSwitch);
        hoverActionGroup.add(windowPreviewsRow);
    }
});

var WindowPreviewOptions = GObject.registerClass(
class azTaskbarWindowPreviewOptions extends Gtk.Window {
    _init(parent, settings) {
        super._init({
            title: _('Window Preview Options'),
            transient_for: parent,
            modal: true,
            default_width: 600,
            default_height: 425,
        });

        this._settings = settings;

        const mainPage = new Adw.PreferencesPage();
        this.set_child(mainPage);

        const windowPreviewsGroup = new Adw.PreferencesGroup({
            title: _('Window Previews'),
        });
        mainPage.add(windowPreviewsGroup);

        const showDelaySpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 0, upper: 1200, step_increment: 100, page_increment: 100, page_size: 0,
            }),
            climb_rate: 100,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
        });
        showDelaySpinButton.set_value(this._settings.get_int('window-previews-show-timeout'));
        showDelaySpinButton.connect('value-changed', widget => {
            this._settings.set_int('window-previews-show-timeout', widget.get_value());
        });
        const showDelaySpinRow = new Adw.ActionRow({
            title: _('Show Window Previews Delay'),
            subtitle: _('Time in ms to show the window preview'),
            activatable_widget: showDelaySpinButton,
        });
        showDelaySpinRow.add_suffix(showDelaySpinButton);
        windowPreviewsGroup.add(showDelaySpinRow);

        const hideDelaySpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 0, upper: 1200, step_increment: 100, page_increment: 100, page_size: 0,
            }),
            climb_rate: 100,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
        });
        hideDelaySpinButton.set_value(this._settings.get_int('window-previews-hide-timeout'));
        hideDelaySpinButton.connect('value-changed', widget => {
            this._settings.set_int('window-previews-hide-timeout', widget.get_value());
        });
        const hideDelaySpinRow = new Adw.ActionRow({
            title: _('Hide Window Previews Delay'),
            subtitle: _('Time in ms to hide the window preview'),
            activatable_widget: hideDelaySpinButton,
        });
        hideDelaySpinRow.add_suffix(hideDelaySpinButton);
        windowPreviewsGroup.add(hideDelaySpinRow);

        const windowPeekGroup = new Adw.PreferencesGroup({
            title: _('Window Peeking'),
        });
        mainPage.add(windowPeekGroup);

        const enablePeekSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
        });
        const enablePeekRow = new Adw.ActionRow({
            title: _('Window Peeking'),
            subtitle: _('Hovering a window preview will focus desired window'),
            activatable_widget: enablePeekSwitch,
        });
        enablePeekSwitch.set_active(this._settings.get_boolean('peek-windows'));
        enablePeekSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('peek-windows', widget.get_active());
        });
        enablePeekRow.add_suffix(enablePeekSwitch);
        windowPeekGroup.add(enablePeekRow);

        const peekTimeoutSpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 0, upper: 800, step_increment: 100, page_increment: 100, page_size: 0,
            }),
            climb_rate: 100,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
        });
        peekTimeoutSpinButton.set_value(this._settings.get_int('peek-windows-timeout'));
        peekTimeoutSpinButton.connect('value-changed', widget => {
            this._settings.set_int('peek-windows-timeout', widget.get_value());
        });
        const peekTimeoutSpinRow = new Adw.ActionRow({
            title: _('Window Peeking Delay'),
            subtitle: _('Time in ms to trigger window peek'),
            activatable_widget: peekTimeoutSpinButton,
        });
        peekTimeoutSpinRow.add_suffix(peekTimeoutSpinButton);
        windowPeekGroup.add(peekTimeoutSpinRow);

        const peekOpacitySpinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower: 0, upper: 255, step_increment: 1, page_increment: 1, page_size: 0,
            }),
            climb_rate: 1,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
        });
        peekOpacitySpinButton.set_value(this._settings.get_int('peek-windows-opacity'));
        peekOpacitySpinButton.connect('value-changed', widget => {
            this._settings.set_int('peek-windows-opacity', widget.get_value());
        });
        const peekOpacityRow = new Adw.ActionRow({
            title: _('Window Peeking Opacity'),
            subtitle: _('Opacity of non-focused windows during a window peek'),
            activatable_widget: peekOpacitySpinButton,
        });
        peekOpacityRow.add_suffix(peekOpacitySpinButton);
        windowPeekGroup.add(peekOpacityRow);
    }
});

var AboutPage = GObject.registerClass(
class AzTaskbarAboutPage extends Adw.PreferencesPage {
    _init() {
        super._init({
            title: _('About'),
            icon_name: 'help-about-symbolic',
            name: 'AboutPage',
        });

        // Project Logo, title, description-------------------------------------
        const projectHeaderGroup = new Adw.PreferencesGroup();
        const projectHeaderBox = new Gtk.Box({
            orientation: Gtk.Orientation.VERTICAL,
            hexpand: false,
            vexpand: false,
        });

        const projectImage = new Gtk.Image({
            margin_bottom: 5,
            icon_name: PROJECT_IMAGE,
            pixel_size: 100,
        });

        const projectTitleLabel = new Gtk.Label({
            label: _('App Icons Taskbar'),
            css_classes: ['title-1'],
            vexpand: true,
            valign: Gtk.Align.FILL,
        });

        const projectDescriptionLabel = new Gtk.Label({
            label: _(PROJECT_DESCRIPTION),
            hexpand: false,
            vexpand: false,
        });
        projectHeaderBox.append(projectImage);
        projectHeaderBox.append(projectTitleLabel);
        projectHeaderBox.append(projectDescriptionLabel);
        projectHeaderGroup.add(projectHeaderBox);

        this.add(projectHeaderGroup);
        // -----------------------------------------------------------------------

        // Extension/OS Info and Links Group------------------------------------------------
        const infoGroup = new Adw.PreferencesGroup();

        const projectVersionRow = new Adw.ActionRow({
            title: _('App Icons Taskbar Version'),
        });
        projectVersionRow.add_suffix(new Gtk.Label({
            label: Me.metadata.version.toString(),
            css_classes: ['dim-label'],
        }));
        infoGroup.add(projectVersionRow);

        if (Me.metadata.commit) {
            const commitRow = new Adw.ActionRow({
                title: _('Git Commit'),
            });
            commitRow.add_suffix(new Gtk.Label({
                label: Me.metadata.commit.toString(),
                css_classes: ['dim-label'],
            }));
            infoGroup.add(commitRow);
        }

        const gnomeVersionRow = new Adw.ActionRow({
            title: _('GNOME Version'),
        });
        gnomeVersionRow.add_suffix(new Gtk.Label({
            label: imports.misc.config.PACKAGE_VERSION.toString(),
            css_classes: ['dim-label'],
        }));
        infoGroup.add(gnomeVersionRow);

        const osRow = new Adw.ActionRow({
            title: _('OS Name'),
        });

        const name = GLib.get_os_info('NAME');
        const prettyName = GLib.get_os_info('PRETTY_NAME');

        osRow.add_suffix(new Gtk.Label({
            label: prettyName ? prettyName : name,
            css_classes: ['dim-label'],
        }));
        infoGroup.add(osRow);

        const sessionTypeRow = new Adw.ActionRow({
            title: _('Windowing System'),
        });
        sessionTypeRow.add_suffix(new Gtk.Label({
            label: GLib.getenv('XDG_SESSION_TYPE') === 'wayland' ? 'Wayland' : 'X11',
            css_classes: ['dim-label'],
        }));
        infoGroup.add(sessionTypeRow);

        const gitlabRow = this._createLinkRow(_('App Icons Taskbar GitLab'), Me.metadata.url);
        infoGroup.add(gitlabRow);

        const donateRow = this._createLinkRow(_('Donate via PayPal'), PAYPAL_LINK);
        infoGroup.add(donateRow);

        this.add(infoGroup);
        // -----------------------------------------------------------------------

        // Save/Load Settings----------------------------------------------------------
        const settingsGroup = new Adw.PreferencesGroup();
        const settingsRow = new Adw.ActionRow({
            title: _('App Icons Taskbar Settings'),
        });
        const loadButton = new Gtk.Button({
            label: _('Load'),
            valign: Gtk.Align.CENTER,
        });
        loadButton.connect('clicked', () => {
            this._showFileChooser(
                _('Load Settings'),
                { action: Gtk.FileChooserAction.OPEN },
                '_Open',
                filename => {
                    if (filename && GLib.file_test(filename, GLib.FileTest.EXISTS)) {
                        const settingsFile = Gio.File.new_for_path(filename);
                        let [success_, pid_, stdin, stdout, stderr] =
                            GLib.spawn_async_with_pipes(
                                null,
                                ['dconf', 'load', SCHEMA_PATH],
                                null,
                                GLib.SpawnFlags.SEARCH_PATH | GLib.SpawnFlags.DO_NOT_REAP_CHILD,
                                null
                            );

                        stdin = new Gio.UnixOutputStream({ fd: stdin, close_fd: true });
                        GLib.close(stdout);
                        GLib.close(stderr);

                        stdin.splice(settingsFile.read(null),
                            Gio.OutputStreamSpliceFlags.CLOSE_SOURCE |
                            Gio.OutputStreamSpliceFlags.CLOSE_TARGET,
                            null);
                    }
                }
            );
        });
        const saveButton = new Gtk.Button({
            label: _('Save'),
            valign: Gtk.Align.CENTER,
        });
        saveButton.connect('clicked', () => {
            this._showFileChooser(
                _('Save Settings'),
                { action: Gtk.FileChooserAction.SAVE },
                '_Save',
                filename => {
                    const file = Gio.file_new_for_path(filename);
                    const raw = file.replace(null, false, Gio.FileCreateFlags.NONE, null);
                    const out = Gio.BufferedOutputStream.new_sized(raw, 4096);

                    out.write_all(GLib.spawn_command_line_sync(`dconf dump ${SCHEMA_PATH}`)[1], null);
                    out.close(null);
                }
            );
        });
        settingsRow.add_suffix(saveButton);
        settingsRow.add_suffix(loadButton);
        settingsGroup.add(settingsRow);
        this.add(settingsGroup);
        // -----------------------------------------------------------------------

        const gnuSoftwareGroup = new Adw.PreferencesGroup();
        const gnuSofwareLabel = new Gtk.Label({
            label: _(GNU_SOFTWARE),
            use_markup: true,
            justify: Gtk.Justification.CENTER,
        });
        const gnuSofwareLabelBox = new Gtk.Box({
            orientation: Gtk.Orientation.VERTICAL,
            valign: Gtk.Align.END,
            vexpand: true,
        });
        gnuSofwareLabelBox.append(gnuSofwareLabel);
        gnuSoftwareGroup.add(gnuSofwareLabelBox);
        this.add(gnuSoftwareGroup);
    }

    _createLinkRow(title, uri) {
        const image = new Gtk.Image({
            icon_name: 'adw-external-link-symbolic',
            valign: Gtk.Align.CENTER,
        });
        const linkRow = new Adw.ActionRow({
            title: _(title),
            activatable: true,
        });
        linkRow.connect('activated', () => {
            Gtk.show_uri(this.get_root(), uri, Gdk.CURRENT_TIME);
        });
        linkRow.add_suffix(image);

        return linkRow;
    }

    _showFileChooser(title, params, acceptBtn, acceptHandler) {
        const dialog = new Gtk.FileChooserDialog({
            title: _(title),
            transient_for: this.get_root(),
            modal: true,
            action: params.action,
        });
        dialog.add_button('_Cancel', Gtk.ResponseType.CANCEL);
        dialog.add_button(acceptBtn, Gtk.ResponseType.ACCEPT);

        dialog.connect('response', (self, response) => {
            if (response === Gtk.ResponseType.ACCEPT) {
                try {
                    acceptHandler(dialog.get_file().get_path());
                } catch (e) {
                    log(`AppsIconTaskbar - Filechooser error: ${e}`);
                }
            }
            dialog.destroy();
        });

        dialog.show();
    }
});

function init() {
    ExtensionUtils.initTranslations();
}

function fillPreferencesWindow(window) {
    const iconTheme = Gtk.IconTheme.get_for_display(Gdk.Display.get_default());
    if (!iconTheme.get_search_path().includes(`${Me.path}/media`))
        iconTheme.add_search_path(`${Me.path}/media`);

    const settings = ExtensionUtils.getSettings();

    window.set_search_enabled(true);

    const generalPage = new GeneralPage(settings);
    window.add(generalPage);

    const actionsPage = new ActionsPage(settings);
    window.add(actionsPage);

    const aboutPage = new AboutPage();
    window.add(aboutPage);
}

var GNU_SOFTWARE = '<span size="small">' +
    'This program comes with absolutely no warranty.\n' +
    'See the <a href="https://gnu.org/licenses/old-licenses/gpl-2.0.html">' +
    'GNU General Public License, version 2 or later</a> for details.' +
    '</span>';
