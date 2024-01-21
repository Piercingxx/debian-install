/* exported NotificationsMonitor */

/*
* Code in this file borrowed from Dash to Dock
* https://github.com/micheleg/dash-to-dock/blob/master/notificationsMonitor.js
* Modified slightly to suit this extensions needs.
*/

const { signals: Signals } = imports;

const { Gio } = imports.gi;
const { main: Main } = imports.ui;

var NotificationsMonitor = class azTaskbarNotificationsManager {
    constructor() {
        this._settings = new Gio.Settings({
            schema_id: 'org.gnome.desktop.notifications',
        });

        this._appNotifications = Object.create(null);
        this._signalsHandler = new Map();

        this._isEnabled = this._settings.get_boolean('show-banners');
        this._showBannersId = this._settings.connect('changed::show-banners', () => {
            const isEnabled = this._settings.get_boolean('show-banners');
            if (isEnabled !== this._isEnabled) {
                this._isEnabled = isEnabled;
                this.emit('state-changed');

                this._updateState();
            }
        });

        this._updateState();
    }

    _disconnectMessageTray() {
        if (this._sourceAddedId) {
            Main.messageTray.disconnect(this._sourceAddedId);
            this._sourceAddedId = null;
        }

        if (this._sourceRemovedId) {
            Main.messageTray.disconnect(this._sourceRemovedId);
            this._sourceRemovedId = null;
        }
    }

    destroy() {
        this.emit('destroy');

        this._disconnectMessageTray();

        if (this._showBannersId) {
            this._settings.disconnect(this._showBannersId);
            this._showBannersId = null;
        }

        this._appNotifications = null;
        this._settings = null;
    }

    get enabled() {
        return this._isEnabled;
    }

    getAppNotificationsCount(appId) {
        return this._appNotifications[appId] ?? 0;
    }

    _updateState() {
        if (this.enabled) {
            if (!this._sourceAddedId) {
                this._sourceAddedId = Main.messageTray.connect('source-added',
                    () => this._checkNotifications());
            }
            if (!this._sourceRemovedId) {
                this._sourceRemovedId = Main.messageTray.connect('source-removed',
                    () => this._checkNotifications());
            }
        } else {
            this._disconnectMessageTray();
        }

        this._checkNotifications();
    }

    _checkNotifications() {
        this._appNotifications = Object.create(null);
        this._signalsHandler.forEach((object, id) => {
            object.disconnect(id);
            id = null;
        });
        this._signalsHandler = new Map();

        if (this.enabled) {
            Main.messageTray.getSources().forEach(source => {
                this._signalsHandler.set(source.connect('notification-added',
                    () => this._checkNotifications()), source);

                source.notifications.forEach(notification => {
                    const app = notification.source?.app ?? notification.source?._app;

                    if (app?.id) {
                        this._signalsHandler.set(notification.connect('destroy',
                            () => this._checkNotifications()), notification);

                        this._appNotifications[app.id] =
                            (this._appNotifications[app.id] ?? 0) + 1;
                    }
                });
            });
        }

        this.emit('changed');
    }
};

Signals.addSignalMethods(NotificationsMonitor.prototype);
