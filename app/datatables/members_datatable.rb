class MembersDatatable
  delegate :params, :link_to, :edit_member_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Member.count,
      iTotalDisplayRecords: members.total_entries,
      aaData: data
    }
  end

  private

    def data
      members.map do |member|
        [
          ERB::Util.h(member.first_name),
          # ERB::Util.h(member.middle_name),
          ERB::Util.h(member.last_name),
          # ERB::Util.h(member.suffix),
          # ERB::Util.h(member.occupation),
          # ERB::Util.h(member.member_number),
          ERB::Util.h(member.address),
          # ERB::Util.h(member.address_2),
          ERB::Util.h(member.city),
          ERB::Util.h(member.state),
          # ERB::Util.h(member.zip),
          # ERB::Util.h(member.country),
          # ERB::Util.h(member.email),
          # ERB::Util.h(member.phone),
          # ERB::Util.h(member.phone_wk),
          # ERB::Util.h(member.employer),
          # ERB::Util.h(member.activity_code),
          ERB::Util.h(member.expiration_date),
          ERB::Util.h(member.longitude),
          ERB::Util.h(member.latitude),
          ERB::Util.h(member.senate_district_no),
          ERB::Util.h(member.senate_name),
          ERB::Util.h(member.senate_phone),
          ERB::Util.h(member.rep_district_no),
          ERB::Util.h(member.rep_name),
          ERB::Util.h(member.rep_phone),
          "#{link_to('Show', member)} | #{link_to('Edit', edit_member_path(member))} | #{link_to('Destroy', member, method: :delete, data: { confirm: 'Are you sure?'})}"
        ]
      end
    end

    def members
      @members ||= fetch_members
    end

    def fetch_members
      members = Member.order("#{sort_column} #{sort_direction}").load
      members = members.page(page).per_page(per_page)
      if params[:sSearch].present?
        members = members.where("first_name like :search or last_name like :search or city like :search", search: "%#{params[:sSearch]}%")
      end
      members
    end

    def page
      params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
      columns = %w[last_name first_name zip]
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
end





