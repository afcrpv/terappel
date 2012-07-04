# encoding: UTF-8

class DossiersDatatable
  delegate :params, :safe_concat, :h, :link_to, to: :@view

  def initialize view
    @view = view
  end



  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Dossier.count,
      iTotalDisplayRecords: dossiers.total_entries,
      aaData: data
    }
  end

  private

  def data
    dossiers.map do |dossier|
      [
        dossier.code,
        dossier.date_appel,
        dossier.name,
        dossier.motif_code,
        dossier.expositions,
        dossier.evolution,
        dossier.malformation,
        dossier.pathologie,
        link_to(("<i class='icon-eye-open'></i>").html_safe, "#", id: dossier.id, class: "btn btn-small opener", title: "Aperçu du dossier #{dossier.code}") + link_to(("<i class='icon-info-sign'></i>").html_safe, dossier, class: "btn btn-small", title: "Détails du dossier #{dossier.code}")
      ]
    end
  end

  def dossiers
    @dossiers ||= fetch_dossiers
  end

  def fetch_dossiers
    dossiers = Dossier.order("#{sort_column} #{sort_direction}") if sort_column
    dossiers = dossiers.page(page).per_page(per_page)
    if params[:sSearch].present?
      dossiers = dossiers.where("LOWER(name) like :search", search: "%#{params[:sSearch]}%")
    end
    DossierDecorator.decorate(dossiers)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = ["code", "date_appel", "name", "motif_id", nil, "evolution", "malformation", "pathologie"]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
