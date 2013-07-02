# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130702092654) do

  create_table "active_admin_comments", force: true do |t|
    t.integer  "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "argumentaires", force: true do |t|
    t.integer  "main_argument_id"
    t.integer  "aux_argument_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "arguments", force: true do |t|
    t.string   "name"
    t.string   "nature"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "arguments", ["slug"], name: "index_arguments_on_slug", unique: true, using: :btree

  create_table "articles", force: true do |t|
    t.text     "titre"
    t.integer  "revue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "contenu"
    t.boolean  "fiche_technique"
    t.integer  "position"
    t.integer  "authorships_count", default: 0
  end

  create_table "articles_categories", id: false, force: true do |t|
    t.integer "article_id"
    t.integer "categorie_id"
  end

  create_table "atcs", force: true do |t|
    t.string   "libelle"
    t.string   "libabr"
    t.integer  "level"
    t.string   "ancestry"
    t.integer  "parent_id"
    t.integer  "codetermepere"
    t.integer  "codeterme"
    t.integer  "oldid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "atcs", ["ancestry"], name: "index_atcs_on_ancestry", using: :btree

  create_table "authors", force: true do |t|
    t.string   "nom"
    t.string   "prenom"
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "authorships_count", default: 0
    t.string   "slug"
  end

  add_index "authors", ["slug"], name: "index_authors_on_slug", unique: true, using: :btree

  create_table "authorships", force: true do |t|
    t.integer  "article_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bebes", force: true do |t|
    t.integer  "dossier_id"
    t.string   "malformation"
    t.string   "pathologie"
    t.string   "sexe"
    t.integer  "poids"
    t.integer  "apgar1"
    t.integer  "apgar5"
    t.integer  "pc"
    t.integer  "taille"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "age"
    t.integer  "oldid"
  end

  create_table "bebes_malformations", id: false, force: true do |t|
    t.integer "bebe_id"
    t.integer "malformation_id"
  end

  create_table "bebes_pathologies", id: false, force: true do |t|
    t.integer "bebe_id"
    t.integer "pathologie_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categoriesps", force: true do |t|
    t.string   "name"
    t.integer  "oldid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "centres", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "centres", ["slug"], name: "index_centres_on_slug", unique: true, using: :btree

  create_table "classifications", force: true do |t|
    t.integer  "produit_id"
    t.integer  "atc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "classifications", ["atc_id"], name: "index_classifications_on_atc_id", using: :btree
  add_index "classifications", ["produit_id"], name: "index_classifications_on_produit_id", using: :btree

  create_table "compositions", force: true do |t|
    t.integer  "produit_id"
    t.integer  "dci_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compositions", ["dci_id"], name: "index_compositions_on_dci_id", using: :btree
  add_index "compositions", ["produit_id"], name: "index_compositions_on_produit_id", using: :btree

  create_table "correspondants", force: true do |t|
    t.integer  "specialite_id"
    t.integer  "qualite_id"
    t.integer  "formule_id"
    t.string   "nom"
    t.text     "adresse"
    t.string   "cp"
    t.string   "ville"
    t.string   "telephone"
    t.string   "fax"
    t.string   "poste"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fullname"
    t.integer  "centre_id"
  end

  add_index "correspondants", ["cp"], name: "index_correspondants_on_cp", using: :btree
  add_index "correspondants", ["nom"], name: "index_correspondants_on_nom", using: :btree
  add_index "correspondants", ["qualite_id"], name: "index_correspondants_on_qualite_id", using: :btree
  add_index "correspondants", ["specialite_id"], name: "index_correspondants_on_specialite_id", using: :btree
  add_index "correspondants", ["ville"], name: "index_correspondants_on_ville", using: :btree

  create_table "dcis", force: true do |t|
    t.string   "libelle"
    t.integer  "oldid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dcis", ["libelle"], name: "index_dcis_on_libelle", unique: true, using: :btree

  create_table "demandeurs", force: true do |t|
    t.integer  "dossier_id"
    t.integer  "correspondant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "demandeurs", ["correspondant_id"], name: "index_demandeurs_on_correspondant_id", using: :btree
  add_index "demandeurs", ["dossier_id"], name: "index_demandeurs_on_dossier_id", using: :btree

  create_table "dossiers", force: true do |t|
    t.date     "date_appel"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "centre_id"
    t.string   "code"
    t.integer  "evolution_id"
    t.integer  "categoriesp_id"
    t.integer  "motif_id"
    t.string   "modaccouch"
    t.date     "date_dernieres_regles"
    t.date     "date_reelle_accouchement"
    t.date     "date_accouchement_prevu"
    t.date     "date_debut_grossesse"
    t.string   "prenom"
    t.integer  "age"
    t.string   "antecedents_perso"
    t.string   "antecedents_fam"
    t.string   "ass_med_proc"
    t.string   "expo_terato"
    t.string   "path_mat"
    t.string   "tabac"
    t.string   "alcool"
    t.string   "a_relancer"
    t.integer  "fcs"
    t.integer  "geu"
    t.integer  "miu"
    t.integer  "ivg"
    t.integer  "nai"
    t.integer  "age_grossesse"
    t.integer  "terme"
    t.integer  "relance_counter"
    t.text     "comm_antecedents_perso"
    t.text     "comm_antecedents_fam"
    t.text     "commentaire"
    t.text     "comm_expo"
    t.text     "comm_evol"
    t.text     "comm_bebe"
    t.integer  "img"
    t.integer  "grsant"
    t.integer  "toxiques"
    t.date     "date_naissance"
    t.integer  "poids"
    t.integer  "taille"
    t.integer  "folique"
    t.integer  "patho1t"
    t.string   "evolution"
    t.date     "date_recueil_evol"
    t.integer  "imc"
    t.integer  "nident"
    t.integer  "nrelance"
  end

  add_index "dossiers", ["categoriesp_id"], name: "index_dossiers_on_categoriesp_id", using: :btree
  add_index "dossiers", ["code"], name: "index_dossiers_on_code", unique: true, using: :btree
  add_index "dossiers", ["date_appel"], name: "index_dossiers_on_date_appel", using: :btree
  add_index "dossiers", ["evolution_id"], name: "index_dossiers_on_evolution_id", using: :btree
  add_index "dossiers", ["expo_terato"], name: "index_dossiers_on_expo_terato", using: :btree
  add_index "dossiers", ["modaccouch"], name: "index_dossiers_on_mod_accouch_id", using: :btree
  add_index "dossiers", ["motif_id"], name: "index_dossiers_on_motif_id", using: :btree
  add_index "dossiers", ["name"], name: "index_dossiers_on_name", using: :btree

  create_table "editorials", force: true do |t|
    t.text     "titre"
    t.text     "contenu"
    t.integer  "author_id"
    t.integer  "revue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expo_natures", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  create_table "expo_termes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  create_table "expo_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  create_table "expositions", force: true do |t|
    t.integer  "produit_id"
    t.integer  "dossier_id"
    t.string   "nappelsaisi"
    t.integer  "expo_type_id"
    t.integer  "indication_id"
    t.integer  "expo_terme_id"
    t.integer  "expo_nature_id"
    t.integer  "numord"
    t.integer  "duree"
    t.integer  "duree2"
    t.string   "dose"
    t.integer  "de"
    t.integer  "a"
    t.integer  "de2"
    t.integer  "a2"
    t.string   "medpres"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "voie_id"
    t.date     "de_date"
    t.date     "de2_date"
    t.date     "a_date"
    t.date     "a2_date"
    t.integer  "oldid"
  end

  create_table "formules", force: true do |t|
    t.integer  "oldid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "indications", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  create_table "malformations", force: true do |t|
    t.string   "libelle"
    t.string   "libabr"
    t.integer  "level"
    t.string   "ancestry"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "codetermepere"
    t.integer  "codeterme"
    t.integer  "oldid"
  end

  add_index "malformations", ["ancestry"], name: "index_malformations_on_ancestry", using: :btree

  create_table "motifs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  create_table "pathologies", force: true do |t|
    t.string   "libelle"
    t.string   "libabr"
    t.integer  "level"
    t.string   "ancestry"
    t.integer  "parent_id"
    t.integer  "codetermepere"
    t.integer  "codeterme"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  add_index "pathologies", ["ancestry"], name: "index_pathologies_on_ancestry", using: :btree

  create_table "produits", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  create_table "produits_searches", id: false, force: true do |t|
    t.integer "produit_id"
    t.integer "search_id"
  end

  create_table "qualites", force: true do |t|
    t.integer  "oldid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "redactionships", force: true do |t|
    t.integer "revue_id"
    t.integer "author_id"
  end

  create_table "relances", force: true do |t|
    t.integer  "dossier_id"
    t.integer  "correspondant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relances", ["correspondant_id"], name: "index_relances_on_correspondant_id", using: :btree
  add_index "relances", ["dossier_id"], name: "index_relances_on_dossier_id", using: :btree

  create_table "revues", force: true do |t|
    t.integer  "numero"
    t.date     "date_sortie"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "articles_count", default: 0
    t.string   "pdf_url"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "searches", force: true do |t|
    t.date     "min_date_appel"
    t.integer  "centre_id"
    t.date     "max_date_appel"
    t.integer  "motif_id"
    t.integer  "expo_nature_id"
    t.integer  "expo_type_id"
    t.integer  "indication_id"
    t.integer  "expo_terme_id"
    t.integer  "evolution"
    t.string   "malformation"
    t.string   "pathologie"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "produit_id"
    t.integer  "dci_id"
  end

  create_table "specialites", force: true do |t|
    t.integer  "oldid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "centre_id"
    t.boolean  "approved"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "voies", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
