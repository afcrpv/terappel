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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111128160120) do

  create_table "admins", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "centres", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "centres", ["slug"], :name => "index_centres_on_slug", :unique => true

  create_table "correspondants", :force => true do |t|
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
  end

  add_index "correspondants", ["cp"], :name => "index_correspondants_on_cp"
  add_index "correspondants", ["nom"], :name => "index_correspondants_on_nom"
  add_index "correspondants", ["qualite_id"], :name => "index_correspondants_on_qualite_id"
  add_index "correspondants", ["specialite_id"], :name => "index_correspondants_on_specialite_id"
  add_index "correspondants", ["ville"], :name => "index_correspondants_on_ville"

  create_table "dossiers", :force => true do |t|
    t.date     "date_appel"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "centre_id"
    t.string   "code"
    t.integer  "evolution_id"
    t.integer  "correspondant_id"
    t.integer  "categoriesp_id"
    t.integer  "motif_id"
    t.integer  "mod_accouch_id"
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
    t.integer  "tabac"
    t.integer  "alcool"
    t.integer  "a_relancer"
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
  end

  add_index "dossiers", ["categoriesp_id"], :name => "index_dossiers_on_categoriesp_id"
  add_index "dossiers", ["code"], :name => "index_dossiers_on_code", :unique => true
  add_index "dossiers", ["correspondant_id"], :name => "index_dossiers_on_correspondant_id"
  add_index "dossiers", ["date_appel"], :name => "index_dossiers_on_date_appel"
  add_index "dossiers", ["evolution_id"], :name => "index_dossiers_on_evolution_id"
  add_index "dossiers", ["expo_terato"], :name => "index_dossiers_on_expo_terato"
  add_index "dossiers", ["mod_accouch_id"], :name => "index_dossiers_on_mod_accouch_id"
  add_index "dossiers", ["motif_id"], :name => "index_dossiers_on_motif_id"
  add_index "dossiers", ["name"], :name => "index_dossiers_on_name"

  create_table "motifs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",            :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",            :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "centre_id"
    t.string   "role",                                  :default => "centre_user"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
