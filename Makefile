RPMS_DIR=rpm/
VERSION := $(shell cat version)
help:
	@echo "make rpms                  -- generate binary rpm packages"
	@echo "make res                   -- compile resources"
	@echo "make update-repo-current   -- copy newly generated rpms to qubes yum repo"
	@echo "make update-repo-unstable  -- same, but to -testing repo"
	@echo "make update-repo-installer -- copy dom0 rpms to installer repo"


rpms: rpms-dom0

rpms-vm:

rpms-dom0:
	rpmbuild --define "_rpmdir $(RPMS_DIR)" -bb rpm_spec/qmgr.spec
	rpm --addsign $(RPMS_DIR)/x86_64/qubes-manager*$(VERSION)*.rpm

res:
	pyrcc4 -o qubesmanager/resources_rc.py resources.qrc
	pyuic4 -o qubesmanager/ui_mainwindow.py mainwindow.ui
	pyuic4 -o qubesmanager/ui_newappvmdlg.py newappvmdlg.ui
	pyuic4 -o qubesmanager/ui_newfwruledlg.py newfwruledlg.ui
	pyuic4 -o qubesmanager/ui_multiselectwidget.py multiselectwidget.ui
	pyuic4 -o qubesmanager/ui_settingsdlg.py settingsdlg.ui
	pyuic4 -o qubesmanager/ui_restoredlg.py restoredlg.ui
	pyuic4 -o qubesmanager/ui_backupdlg.py backupdlg.ui
	pyuic4 -o qubesmanager/ui_globalsettingsdlg.py globalsettingsdlg.ui
	pyuic4 -o qubesmanager/ui_logdlg.py logdlg.ui
	pyuic4 -o qubesmanager/ui_about.py about.ui
	pyuic4 -o qubesmanager/ui_releasenotes.py releasenotes.ui
	pyuic4 -o qubesmanager/ui_informationnotes.py informationnotes.ui
	pyuic4 -o qubesmanager/ui_networknotes.py networknotes.ui

update-repo-current:
	ln -f $(RPMS_DIR)/x86_64/qubes-manager-*$(VERSION)*.rpm ../yum/current-release/current/dom0/rpm/

update-repo-current-testing:
	ln -f $(RPMS_DIR)/x86_64/qubes-manager-*$(VERSION)*.rpm ../yum/current-release/current-testing/dom0/rpm/

update-repo-unstable:
	ln -f $(RPMS_DIR)/x86_64/qubes-manager-*$(VERSION)*.rpm ../yum/current-release/unstable/dom0/rpm/

update-repo-installer:
	ln -f $(RPMS_DIR)/x86_64/qubes-manager-*$(VERSION)*.rpm ../installer/yum/qubes-dom0/rpm/

clean:
