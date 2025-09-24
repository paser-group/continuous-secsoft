# == class: zaqar::management::sqlalchemy
#
# [*uri*]
#   SQLAlchemy Connection URI. Required.
#
class zaqar::management::sqlalchemy(
  $uri,
) {

  include ::zaqar::deps

  zaqar_config {
    'drivers:management_store:sqlalchemy/uri': value => $uri, secret => true;
  }

}
