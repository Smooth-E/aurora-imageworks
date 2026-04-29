Name:       moe.smoothie.imageworks

# >> macros
%define __provides_exclude_from ^%{_datadir}/%{name}/lib/.*\\.so\\>
%define __requires_exclude_from ^%{_datadir}/%{name}/lib/.*\\.so\\>

%define __requires_exclude (libpython3*|libpyside2*|libcrypt.*|libffi.*|python3dist|lib.*)
%define __provides_exclude_from ^%{_datadir}/.*$
# << macros

Summary:    Imageworks image editor
Version:    1.2.1
Release:    1
Group:      Qt/Qt
License:    GPLv3
URL:        https://github.com/poetaster/harbour-simplecrop
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9

BuildRequires:  pkgconfig(auroraapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Image editing application for Sailfish OS.


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
# >> install pre
# << install pre
%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_libexecdir}/%{name}
%defattr(644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files
